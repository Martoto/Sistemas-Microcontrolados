// main.c

#define FSM_STOPPED 1
#define FSM_INPUTDIRECTION 2
#define FSM_INPUTMODE_A 3
#define FSM_INPUTMODE_H 4
#define FSM_RUNNING_AA 5
#define FSM_RUNNING_AH 6
#define FSM_RUNNING_HA 7
#define FSM_RUNNING_HH 8

#define SENTIDO_HORARIO 0x02
#define SENTIDO_ANTIHORARIO 0x01
#define ADC_MAX  4096.0f

#include "tm4c1294ncpdt.h"
#include <stdint.h>
#include <stdio.h>

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void GPIO_Init(void);
uint32_t PortJ_Input(void);
uint32_t ADC9_Input(void);
void Interrupt(void);
void TIMER2_Init(void);
void UART0_Init(void);
void ADC_init (void);
void WriteOutUart ();
uint8_t Uart0_Rcv(void);
uint8_t Uart0_Rcv_Async(void);
void Uart0_Send(uint8_t charactere);
void Uart0_Send_Msg(uint8_t* msg, int32_t size);
float calculateAdc9Ratio();

int16_t actualStateFsm = 0;

int32_t pwmOn = 0;
float dutycycle = 1;

int main(void) {
	PLL_Init();
	SysTick_Init();
	UART0_Init();
	GPIO_Init();
	Interrupt();	
	TIMER2_Init();
	ADC_init();
	
	actualStateFsm = FSM_STOPPED;
	
	Uart0_Send_Msg("\r\n MOTOR PARADO", 15);
	SysTick_Wait1ms(1000);
	actualStateFsm = FSM_INPUTDIRECTION;
	
	while (1) {
		
		if (actualStateFsm == FSM_INPUTDIRECTION) {
			Uart0_Send_Msg("\r\n SELECIONAR SENTIDO", 21);
			Uart0_Send_Msg("\r\n 'a' ou 'h'", 11);
		}
		while (actualStateFsm == FSM_INPUTDIRECTION) {
			uint8_t uartInput = Uart0_Rcv();
			if (uartInput == 'a') {
				actualStateFsm = FSM_INPUTMODE_A;
			} else if (uartInput == 'h') {
				actualStateFsm = FSM_INPUTMODE_H;
			}
		}  
		
		//FSM_INPUTMODE_A
		if (actualStateFsm == FSM_INPUTMODE_A) {
			Uart0_Send_Msg("\r\n <- ANTI-HORARIO <-", 21);
			Uart0_Send_Msg("\r\n SELECIONAR MODO", 18);
			Uart0_Send_Msg("\r\n 'a' -> terminal", 18);
			Uart0_Send_Msg("\r\n 'h' -> reostato", 18);
			Uart0_Send_Msg("\r\n ---------------------\r\n", 26);
			GPIO_PORTE_AHB_DATA_R = SENTIDO_ANTIHORARIO;
		}
		while (actualStateFsm == FSM_INPUTMODE_A) {
			uint8_t uartInput = Uart0_Rcv();
			if (uartInput == 'a') {
				actualStateFsm = FSM_RUNNING_AA;
			} else if (uartInput == 'h') {
				actualStateFsm = FSM_RUNNING_AH;
			}
		}  
		
		//FSM_INPUTMODE_H
		if (actualStateFsm == FSM_INPUTMODE_H) {
			Uart0_Send_Msg("\r\n -> HORARIO ->", 21);
			Uart0_Send_Msg("\r\n SELECIONAR MODO", 18);
			Uart0_Send_Msg("\r\n 'a' -> terminal", 18);
			Uart0_Send_Msg("\r\n 'h' -> reostato", 18);
			Uart0_Send_Msg("\r\n ---------------------\r\n", 26);
			GPIO_PORTE_AHB_DATA_R = SENTIDO_HORARIO;
		}
		while (actualStateFsm == FSM_INPUTMODE_H) {
			uint8_t uartInput = Uart0_Rcv();
			if (uartInput == 'a') {
				actualStateFsm = FSM_RUNNING_HA;
			} else if (uartInput == 'h') {
				actualStateFsm = FSM_RUNNING_HH;
			}
		}  
		
		//FSM_RUNNING_AA
		if (actualStateFsm == FSM_RUNNING_AA) {
			Uart0_Send_Msg("\r\n RECEBENDO VELOCIDADE [1 a 10]", 31);
			GPIO_PORTE_AHB_DATA_R = SENTIDO_ANTIHORARIO;
		}
		while (actualStateFsm == FSM_RUNNING_AA) {
			uint8_t uartInput = Uart0_Rcv();
			if (uartInput == 'h') {
				Uart0_Send_Msg("\r\n -> HORARIO ->", 21);
				actualStateFsm = FSM_RUNNING_HA;
			} else if (uartInput >= '0' && uartInput <= '6') {
					float velocidadeEscolhida = (uartInput - 0x30)*10 + 40;
					if (uartInput == '0') {
						velocidadeEscolhida = 0;
					}						
				dutycycle = velocidadeEscolhida;
				WriteOutUart((int)velocidadeEscolhida);
			}
			
			
		}  
		
		//FSM_RUNNING_HA
		if (actualStateFsm == FSM_RUNNING_HA) {
			Uart0_Send_Msg("\r\n RECEBENDO VELOCIDADE [1 a 10]", 31);
			GPIO_PORTE_AHB_DATA_R = SENTIDO_HORARIO;
		}
		while (actualStateFsm == FSM_RUNNING_HA) {
			uint8_t uartInput = Uart0_Rcv();
			if (uartInput == 'a') {
				Uart0_Send_Msg("\r\n <- ANTI-HORARIO <-", 21);
				actualStateFsm = FSM_RUNNING_AA;
			} else if (uartInput >= '0' && uartInput <= '6') {
				float velocidadeEscolhida = (uartInput - 0x30)*10 + 40;
					if (uartInput == '0') {
						velocidadeEscolhida = 0;
					}						
				dutycycle = velocidadeEscolhida;
				WriteOutUart((int)velocidadeEscolhida);
			}
		}  
		
		//FSM_RUNNING_HH
		if (actualStateFsm == FSM_RUNNING_HH) {
			Uart0_Send_Msg("\r\n VELOCIDADE REOSTATO", 23);
			GPIO_PORTE_AHB_DATA_R = SENTIDO_HORARIO;
		}
		while (actualStateFsm == FSM_RUNNING_HH) {
			uint8_t uartInput = Uart0_Rcv_Async();
			if (uartInput == 'a') {
				Uart0_Send_Msg("\r\n <- ANTI-HORARIO <-", 21);
				actualStateFsm = FSM_RUNNING_AH;
			} 
			dutycycle = calculateAdc9Ratio()*100;
			WriteOutUart ((int)dutycycle);
		}  
		
		//FSM_RUNNING_AH
		if (actualStateFsm == FSM_RUNNING_AH) {
			Uart0_Send_Msg("\r\n VELOCIDADE REOSTATO", 23);
			GPIO_PORTE_AHB_DATA_R = SENTIDO_ANTIHORARIO;
		}
		while (actualStateFsm == FSM_RUNNING_AH) {
			uint8_t uartInput = Uart0_Rcv_Async();
			if (uartInput == 'h') {
				Uart0_Send_Msg("\r\n -> HORARIO ->", 21);
				actualStateFsm = FSM_RUNNING_HH;
			}
			dutycycle = calculateAdc9Ratio()*100;
			WriteOutUart ((int)dutycycle);

		}  
		
	}
}

void WriteOutUart (int velocidade) {
		char buf[64]; 
		int pos = snprintf(buf, sizeof(buf), "\r\n velocidade : %d", velocidade);
    if (sizeof(buf) <= pos)
                    buf[sizeof(buf)-1] = '\0';
    Uart0_Send_Msg((uint8_t*) buf, 21);
}

float calculateAdc9Ratio () {
	return (float)ADC9_Input() / ADC_MAX;
}


void GPIOPortJ_Handler(void)  {
	GPIO_PORTJ_AHB_ICR_R |= 0x3;
	//9. Habilitar e desabilita TIMER_CTL_R para fazer as configurações
	TIMER2_CTL_R^=TIMER_CTL_TAEN;
}

void Timer2A_Handler(void)  {
	TIMER2_CTL_R&=~(TIMER_CTL_TAEN);
	TIMER2_ICR_R|=TIMER_ICR_TATOCINT;
	
	if(pwmOn ==0 ) {
		TIMER2_TAILR_R=(79999*(dutycycle))/100;
		pwmOn=1;
	} else {
		TIMER2_TAILR_R=(79999*(100-dutycycle))/100;
		pwmOn=0;
	}
	
	TIMER2_CTL_R|=TIMER_CTL_TAEN;
	GPIO_PORTF_AHB_DATA_R ^= 0x04; //xor para alternar

}
