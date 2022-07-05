// main.c

#define FSM_INPUT_FIRST 0
#define FSM_INPUT_OPERATION 2
#define FSM_INPUT_SECOND 4
#define FSM_RESULT 8
#define FSM_FINISH 0xFF


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
void WriteOutUart (float velocidade);
uint8_t Uart0_Rcv(void);
uint8_t Uart0_Rcv_Async(void);
void Uart0_Send(uint8_t charactere);
void Uart0_Send_Msg(uint8_t* msg, int32_t size);
float calculateAdc9Ratio();
int isAsciiNumber(uint8_t ascii);
int isAsciiOp(uint8_t ascii);
uint8_t asciiToDecimal (uint8_t ascii);
int scientificToDecimal (int mantissa, int casa);
float calculateResult (int a, int b, int op);
int blinkFlag = 0;
void PortP_Output(uint32_t leds);


int16_t actualStateFsm = 0;

int32_t pwmOn = 0;
float dutycycle = 1;

enum casas{
		unidade = 0, dezena, centena
	};

enum operation {
	nop = 0, sum = 0x01, sub = 0x02, mul = 0x04, div = 0x08, equ
};

int main(void) {
	PLL_Init();
	SysTick_Init();
	GPIO_Init();
	TIMER2_Init();
	UART0_Init();
	PortP_Output(0x20);

	
  int firstNumber = 0, secondNumber = 0;
	uint8_t casa1 = unidade, casa2 = unidade;
	uint8_t op = 0;
	float result = 0;
	
	SysTick_Wait1ms(1000);
	Uart0_Send_Msg("\r\n NNN ^ MMM = XXXXX\r\n", 21);
	Uart0_Send_Msg("\r\n Enter first N\r\n", 21);
	SysTick_Wait1ms(1000);
	actualStateFsm = FSM_INPUT_FIRST;
	
	while (1) {
		
		
		
		while (actualStateFsm == FSM_INPUT_FIRST) {
			uint8_t uartInput = Uart0_Rcv();
			if (isAsciiNumber(uartInput)) {
				actualStateFsm = FSM_INPUT_FIRST;
				firstNumber += scientificToDecimal(asciiToDecimal(uartInput), casa1);
				WriteOutUart(firstNumber);
				if (casa1 == centena) {
					actualStateFsm = FSM_INPUT_OPERATION;
				}
				casa1 += 1;
				
			} else if (isAsciiOp(uartInput)) {
				Uart0_Send_Msg(&uartInput, 1);
				op = isAsciiOp(uartInput);
				blinkFlag = op;
				actualStateFsm = FSM_INPUT_SECOND;
			}
		}
		
		while (actualStateFsm == FSM_INPUT_OPERATION) {
			uint8_t uartInput = Uart0_Rcv();
			if (isAsciiOp(uartInput)) {
				Uart0_Send_Msg(&uartInput, 1);
				op = isAsciiOp(uartInput);
				blinkFlag = op;
				actualStateFsm = FSM_INPUT_SECOND;
			}
		}
		
		blinkFlag = op;
		
		while (actualStateFsm == FSM_INPUT_SECOND) {
			uint8_t uartInput = Uart0_Rcv();
			if (isAsciiNumber(uartInput)) {
				actualStateFsm = FSM_INPUT_SECOND;
				secondNumber += scientificToDecimal(asciiToDecimal(uartInput), casa2);
				WriteOutUart(secondNumber);
				if (casa2 == centena) {
					actualStateFsm = FSM_RESULT;
				}
				casa2 += 1;
				
			} else if (isAsciiOp(uartInput)) {
					if (isAsciiOp(uartInput) == equ) {
							
							actualStateFsm = FSM_RESULT;
					}
			}
		}  
		while (actualStateFsm == FSM_RESULT) {
			Uart0_Send_Msg("\r\n Result: \r\n", 15);
			result = calculateResult(firstNumber, secondNumber, op);
			WriteOutUart(firstNumber);
			WriteOutUart(secondNumber);
			WriteOutUart(result);
			
			actualStateFsm = FSM_FINISH;
		}  
	
		
		
	}
}

float calculateResult (int a, int b, int op) {
	switch (op){
		
		case sum:
			return a + b;
		break;
		
		case sub:
			return a - b;
		break;
		
		case mul:
			return a*b;
		break;
		
		case div:
			return (float)((float)a/(float)b);
		break;
		
		default:
			return 0;
		break;
	}
}

uint8_t asciiToDecimal (uint8_t ascii) {
	return (ascii - 0x30);
}

int scientificToDecimal (int mantissa, int casa) {
	if (casa == unidade) return mantissa;
	if (casa == dezena) return mantissa*10;
	if (casa == centena) return mantissa*100;
}

int isAsciiNumber(uint8_t ascii) {
	if (ascii >= '0' && ascii <= '9') {
		return 1;
	} 
	return 0;
}

int isAsciiOp (uint8_t ascii) {
	if (ascii == '+') return sum;
	if (ascii == '-') return sub; 
	if (ascii == '*') return mul;
	if (ascii == '/') return div;
	if (ascii == '=') return equ;
	
	return nop;
}
void WriteOutUart (float velocidade) {
		char buf[64]; 
		int pos = snprintf(buf, sizeof(buf), "\n \r %f \n \r", velocidade);
    if (sizeof(buf) <= pos)
                    buf[sizeof(buf)-1] = '\0';
    Uart0_Send_Msg((uint8_t*) buf, 24);
}


void GPIOPortJ_Handler(void)  {
	GPIO_PORTJ_AHB_ICR_R |= 0x3;
	//9. Habilitar e desabilita TIMER_CTL_R para fazer as configurações
	TIMER2_CTL_R^=TIMER_CTL_TAEN;
}

