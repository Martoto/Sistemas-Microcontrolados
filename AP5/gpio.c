// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J, F e N
// Prof. Guilherme Peron



//PE4 AIN9 -> Entrada analógica reostato
//PE0 + PE1 -> Saída direção motor DC
//PF2 -> Saída PWM motor DC
//Ligar motor DC nos pinos 2 e 3 (adjacente à VCC) do header 6

//The AINx signals are analog functions for some GPIO signals. The column in the table below titled
//"Pin Mux/Pin Assignment" lists the GPIO pin placement for the ADC signals. These signals are
//configured by clearing the corresponding DEN bit in the GPIO Digital Enable (GPIODEN) register
//and setting the corresponding AMSEL bit in the GPIO Analog Mode Select (GPIOAMSEL) register.
//For more information on configuring GPIOs, see “General-Purpose Input/Outputs
//(GPIOs)” on page 742. The VREFA+ signal (with the word "fixed" in the Pin Mux/Pin Assignment
//column) has a fixed pin assignment and function.\



#include <stdint.h>

#include "tm4c1294ncpdt.h"

  
#define GPIO_PORTJ  (0x0100) //bit 8
#define GPIO_PORTN  (0x1000) //bit 12
#define GPIO_PORTF  (0x0020) //bit 5
#define GPIO_PORTE 	(0x0003) //bit 0, 1
#define GPIO_PORTE_ADC 	(0x0010) //bit 4
#define GPIO_PORTA  (0x0001) //bit 0
#define TIMER2  (0x0004) //bit 3


extern int blinkFlag;

void PortN_Output(uint32_t valor);
void PortQ_Output(uint32_t valor);
void PortP_Output(uint32_t valor);

// -------------------------------------------------------------------------------
// Função GPIO_Init
// Inicializa os ports J e N
// Parâmetro de entrada: Não tem
// Parâmetro de saída: Não tem
void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
	SYSCTL_RCGCGPIO_R = (GPIO_PORTJ | GPIO_PORTN | GPIO_PORTF | GPIO_PORTA | GPIO_PORTE | GPIO_PORTE_ADC | 0x7F81);
	
	//1b.   após isso verificar no PRGPIO se a porta está pronta para uso.
  while((SYSCTL_PRGPIO_R & (GPIO_PORTJ | GPIO_PORTN | GPIO_PORTF | GPIO_PORTA | GPIO_PORTE | 0x7F81) ) != (GPIO_PORTJ | GPIO_PORTN | GPIO_PORTF | GPIO_PORTA | GPIO_PORTE | 0x7F81) ){};
	
	// 2. Limpar o AMSEL para desabilitar a analógica
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
	GPIO_PORTN_AMSEL_R = 0x00;
	GPIO_PORTF_AHB_AMSEL_R = 0x00;
	GPIO_PORTA_AHB_AMSEL_R = 0x00;
	GPIO_PORTQ_AMSEL_R = 0x00;
	GPIO_PORTP_AMSEL_R = 0x00;
		
		
	// 3. Limpar PCTL para selecionar o GPIO
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
	GPIO_PORTN_PCTL_R = 0x00;
	GPIO_PORTQ_PCTL_R = 0x00;
	GPIO_PORTF_AHB_PCTL_R = 0x00;
	GPIO_PORTE_AHB_PCTL_R = 0x00;
	// 3b. Setar PCTL para selecionar o UART
	GPIO_PORTA_AHB_PCTL_R = 0x11;
	GPIO_PORTP_PCTL_R = 0x00;
		
	// 4. DIR para 0 se for entrada, 1 se for saída
	GPIO_PORTJ_AHB_DIR_R = 0x00;
	GPIO_PORTN_DIR_R = 0x03; //BIT0 | BIT1
	GPIO_PORTQ_DIR_R = 0x0F; //BIT0 a BIT4
	GPIO_PORTF_AHB_DIR_R = 0x15; //BIT0 | BIT4 e BIT2
	GPIO_PORTE_AHB_DIR_R = GPIO_PORTE; 
	GPIO_PORTP_DIR_R = 0x20;	//0010 0000	transistor led
		
	// 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem função alternativa	
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
	GPIO_PORTN_AFSEL_R = 0x00; 
	GPIO_PORTQ_AFSEL_R = 0x00; 
	GPIO_PORTF_AHB_AFSEL_R = 0x00;
	// 5b. Setar os bits AFSEL para 1 para selecionar GPIO c função alternativa	
	GPIO_PORTA_AHB_AFSEL_R &= ~0x03; 
	GPIO_PORTA_AHB_AFSEL_R |= 0x03; 
	GPIO_PORTP_AFSEL_R = 0x00;

		
	// 6. Setar os bits de DEN para habilitar I/O digital	
	GPIO_PORTA_AHB_DEN_R = 0x03; 		   //Bit0 e bit1
	GPIO_PORTJ_AHB_DEN_R = 0x03;   //Bit0 e bit1
	GPIO_PORTN_DEN_R = 0x03; 		   //Bit0 e bit1
	GPIO_PORTQ_DEN_R = 0x0F; 		   //Bit0 e bit1
	GPIO_PORTP_DEN_R = 0x20;	//0010 0000	transistor led
	GPIO_PORTF_AHB_DEN_R = 0x15; 		   //Bit0 e bit4
	GPIO_PORTE_AHB_DEN_R = GPIO_PORTE; 		   //Bit0 e bit4
	
	// 7. Habilitar resistor de pull-up interno, setar PUR para 1
	GPIO_PORTJ_AHB_PUR_R = 0x03;   //Bit0 e bit1	

}	

void ADC_init (void) {
	
	SYSCTL_RCGCADC_R = SYSCTL_RCGCADC_R0; //Bit 9 -> AIN9 -> PE4
	GPIO_PORTE_AHB_AMSEL_R = GPIO_PORTE_ADC;
	GPIO_PORTE_AHB_AFSEL_R = GPIO_PORTE_ADC;
	
	while((SYSCTL_PRADC_R & SYSCTL_RCGCADC_R0) != SYSCTL_RCGCADC_R0) {};
		
	//Escolher máxima taxa de amostragem no reg. ADCPC
	ADC0_PC_R = ADC_PC_MCR_FULL;
	
	//Definir SSPRI3 como max = 0 e resto tnto faz
	ADC0_SSPRI_R = 0x123;
		
	//Setar fonte de entrada analógica AIN9
	ADC0_SSMUX3_R = ADC_SSMUX3_MUX0_M & 9;
	ADC0_SSCTL3_R = 0x06;
		
	//habilitar sequenciador
	ADC0_ACTSS_R = ADC_ACTSS_ASEN3;

		
	
}
// -------------------------------------------------------------------------------
// Função PortJ_Input
// Lê os valores de entrada do port J
// Parâmetro de entrada: Não tem
// Parâmetro de saída: o valor da leitura do port

void TIMER2_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCTIMER
	SYSCTL_RCGCTIMER_R = (TIMER2);
	
	//1b.   após isso verificar no PRGPIO se a porta está pronta para uso.
  while((SYSCTL_PRTIMER_R & (TIMER2) ) != (TIMER2)  ){};

	//2. Desabilitar o TIMER_CTL_R para fazer as configurações
	TIMER2_CTL_R&=~(TIMER_CTL_TAEN);
		
	//3. Seleciona o modo 32 bits no registrador GPTMCFG
	TIMER2_CFG_R&=~(0x07);
	TIMER2_CFG_R|=TIMER_CFG_32_BIT_TIMER;

	//4. Seleciona o modo contador periodico registrador GPTMTAMR
	TIMER2_TAMR_R&=~(0x03);
	TIMER2_TAMR_R|=TIMER_TAMR_TAMR_PERIOD;

	//5. Carrega o valor de contagem no registrador do timer A GPTMTAILR
	TIMER2_TAILR_R=0xF42400;	//tempo timer 16M = 200mS


	//6. Zera o prescale do Timer A GPTMTAPR
	TIMER2_TAPR_R&=~(0xFF);
	
	//7. Setar o bit para 1 no registrador GPTMICR para zerar o flag de atendimento de interrupção (ACK)
	TIMER2_ICR_R|=TIMER_ICR_TATOCINT;		

	//8. Setar bit para 1 no registrador GPTMIMR para setar a interrupção do timer 2A
	TIMER2_IMR_R|=TIMER_IMR_TATOIM;		

	//8b. Setar prioridade de interrupção no registrador PRIO 5 para a interrupção de numero 23
	NVIC_PRI5_R=4 << 29;		
	//NVIC_PRI5_R= ~(NVIC_PRI5_INT23_M) Poderia ser uma opção para zerar a prioridade da interrupção de numero 23 sem afetar o resto das interrupções
	
	//8c. Habilitar a interrupção do timer 2A
	NVIC_EN0_R=1 << 23;		

	//9. Habilitar o TIMER_CTL_R para fazer as configurações
	TIMER2_CTL_R|=TIMER_CTL_TAEN;

}


void UART0_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCUART
	SYSCTL_RCGCUART_R= SYSCTL_RCGCUART_R0;

	//1b.   após isso verificar no PRUART se a porta está pronta para uso.
  while((SYSCTL_PRUART_R & (SYSCTL_PRUART_R0) ) != (SYSCTL_PRUART_R0)  ){};

	//2. Desabilitar o TIMER_CTL_R para fazer as configurações
	UART0_CTL_R&=~(UART_CTL_UARTEN);
		
	//3. Seleciona o baud-rate de 9600
	UART0_IBRD_R=520;
	UART0_FBRD_R=56;
		
	//4. Configurar o UARTLCRH para palavras de 8 bits e FIFO ligado;
	UART0_LCRH_R&= ~(0xFF);
	UART0_LCRH_R|= UART_LCRH_WLEN_8;
	UART0_LCRH_R|= UART_LCRH_FEN;
	

	//5. Garantir que a fonte de clock seja o clock do sistema no registrador UARTCC escrevendo 0 (ou escolher qualquer uma das outras fontes de clock)
	UART0_CC_R&=UART_CC_CS_SYSCLK;

	//6. Habilitar as flags RXE, TXE e UARTEN no registrador UARTCTL (habilitar a recepção, transmissão e a UART)
	UART0_CTL_R|=UART_CTL_RXE;
	UART0_CTL_R|=UART_CTL_TXE;
	UART0_CTL_R|=UART_CTL_UARTEN;
		
}


uint32_t PortJ_Input(void)
{
	return GPIO_PORTJ_AHB_DATA_R;
}

uint32_t ADC9_Input(void) {
	//gatilho SW p SS3
	ADC0_PSSI_R = ADC_PSSI_SS3;
	//polling do RIS
	while (ADC0_RIS_R != ADC_RIS_INR3) {};
	uint32_t adcConversionResult =  ADC0_SSFIFO3_R;
	ADC0_ISC_R = 0x0;
	
  return adcConversionResult;
}

// -------------------------------------------------------------------------------
// Função PortN_Output
// Escreve os valores no port N
// Parâmetro de entrada: Valor a ser escrito
// Parâmetro de saída: não tem
void Port_Output(uint32_t N, uint32_t F)
{
    
		GPIO_PORTN_DATA_R &= ~(0x3); 
	
		GPIO_PORTF_AHB_DATA_R &= (0xEE);

    GPIO_PORTN_DATA_R |= N; 
	
		GPIO_PORTF_AHB_DATA_R |= F;
}


void Timer2A_Handler (void) {
	TIMER2_ICR_R = 0x01;
	if (blinkFlag) {
		if (GPIO_PORTQ_DATA_R > 0) {
			PortQ_Output(0x00);
		} else {
			PortQ_Output(blinkFlag);
		}
	} else {
		PortQ_Output(0x00);
	}
	
	return;

}	

void Uart0_Send(uint8_t charactere) {
	while((UART0_FR_R & UART_FR_TXFF) == UART_FR_TXFF)
	{	}
	UART0_DR_R = charactere;
}

void Uart0_Send_Msg(uint8_t* msg, int32_t size) {
	uint8_t charactere;	
	
	for(int32_t i = 0; i < size; i++) {
		charactere = msg[i];
		Uart0_Send(charactere);
	}
	
}

void PortN_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTN_DATA_R & 0xFC; 
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTN_DATA_R = temp; 
}

void PortQ_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTQ_DATA_R ; 
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTQ_DATA_R = valor; 
}

void PortP_Output(uint32_t valor)
{
    uint32_t temp;
    //vamos zerar somente os bits menos significativos
    //para uma escrita amigável nos bits 0 e 1
    temp = GPIO_PORTP_DATA_R & 0xDF; // INVERSO DE 0010 0000
    //agora vamos fazer o OR com o valor recebido na função
    temp = temp | valor;
    GPIO_PORTP_DATA_R = temp; 
}

uint8_t Uart0_Rcv(void) {
	while((UART0_FR_R & UART_FR_RXFE) == UART_FR_RXFE) {}
	return UART0_DR_R & 0xFF;
}

uint8_t Uart0_Rcv_Async(void) {
	//while((UART0_FR_R & UART_FR_RXFE) == UART_FR_RXFE) {}
	return UART0_DR_R & 0xFF;
}


