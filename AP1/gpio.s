;Gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof.Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; ========================
; Definições dos RegistradoresGerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
GPIO_PORTA_AHB_DATA_BITS_R    EQU     0x40058000
; ========================
; Definições dos Ports
; PORT A

GPIO_PORTA_AHB_DATA_R    EQU 0x400583FC
GPIO_PORTA_AHB_DIR_R     EQU 0x40058400
GPIO_PORTA_AHB_IS_R      EQU 0x40058404
GPIO_PORTA_AHB_IBE_R     EQU 0x40058408
GPIO_PORTA_AHB_IEV_R     EQU 0x4005840C
GPIO_PORTA_AHB_IM_R      EQU 0x40058410
GPIO_PORTA_AHB_RIS_R     EQU 0x40058414
GPIO_PORTA_AHB_MIS_R     EQU 0x40058418
GPIO_PORTA_AHB_ICR_R     EQU 0x4005841C
GPIO_PORTA_AHB_AFSEL_R   EQU 0x40058420
GPIO_PORTA_AHB_DR2R_R    EQU 0x40058500
GPIO_PORTA_AHB_DR4R_R    EQU 0x40058504
GPIO_PORTA_AHB_DR8R_R    EQU 0x40058508
GPIO_PORTA_AHB_ODR_R     EQU 0x4005850C
GPIO_PORTA_AHB_PUR_R     EQU 0x40058510
GPIO_PORTA_AHB_PDR_R     EQU 0x40058514
GPIO_PORTA_AHB_SLR_R     EQU 0x40058518
GPIO_PORTA_AHB_DEN_R     EQU 0x4005851C
GPIO_PORTA_AHB_LOCK_R    EQU 0x40058520
GPIO_PORTA_AHB_CR_R      EQU 0x40058524
GPIO_PORTA_AHB_AMSEL_R   EQU 0x40058528
GPIO_PORTA_AHB_PCTL_R    EQU 0x4005852C
GPIO_PORTA_AHB_ADCCTL_R  EQU 0x40058530
GPIO_PORTA_AHB_DMACTL_R  EQU 0x40058534
GPIO_PORTA_AHB_SI_R      EQU 0x40058538
GPIO_PORTA_AHB_DR12R_R   EQU 0x4005853C
GPIO_PORTA_AHB_WAKEPEN_R   EQU 0x40058540
GPIO_PORTA_AHB_WAKELVL_R   EQU 0x40058544
GPIO_PORTA_AHB_WAKESTAT_R  EQU 0x40058548
GPIO_PORTA_AHB_PP_R      EQU 0x40058FC0
GPIO_PORTA_AHB_PC_R      EQU 0x40058FC4
GPIO_PORTA               	EQU    2_000000000000001	
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000
; PORT F
GPIO_PORTF_AHB_LOCK_R    	EQU    0x4005D520
GPIO_PORTF_AHB_CR_R      	EQU    0x4005D524
GPIO_PORTF_AHB_AMSEL_R   	EQU    0x4005D528
GPIO_PORTF_AHB_PCTL_R    	EQU    0x4005D52C
GPIO_PORTF_AHB_DIR_R     	EQU    0x4005D400
GPIO_PORTF_AHB_AFSEL_R   	EQU    0x4005D420
GPIO_PORTF_AHB_DEN_R     	EQU    0x4005D51C
GPIO_PORTF_AHB_PUR_R     	EQU    0x4005D510	
GPIO_PORTF_AHB_DATA_R    	EQU    0x4005D3FC
GPIO_PORTF               	EQU    2_000000000100000	
; PORT P

GPIO_PORTP_DATA_R        EQU 0x400653FC
GPIO_PORTP_DIR_R         EQU 0x40065400
GPIO_PORTP_IS_R          EQU 0x40065404
GPIO_PORTP_IBE_R         EQU 0x40065408
GPIO_PORTP_IEV_R         EQU 0x4006540C
GPIO_PORTP_IM_R          EQU 0x40065410
GPIO_PORTP_RIS_R         EQU 0x40065414
GPIO_PORTP_MIS_R         EQU 0x40065418
GPIO_PORTP_ICR_R         EQU 0x4006541C
GPIO_PORTP_AFSEL_R       EQU 0x40065420
GPIO_PORTP_DR2R_R        EQU 0x40065500
GPIO_PORTP_DR4R_R        EQU 0x40065504
GPIO_PORTP_DR8R_R        EQU 0x40065508
GPIO_PORTP_ODR_R         EQU 0x4006550C
GPIO_PORTP_PUR_R         EQU 0x40065510
GPIO_PORTP_PDR_R         EQU 0x40065514
GPIO_PORTP_SLR_R         EQU 0x40065518
GPIO_PORTP_DEN_R         EQU 0x4006551C
GPIO_PORTP_LOCK_R        EQU 0x40065520
GPIO_PORTP_CR_R          EQU 0x40065524
GPIO_PORTP_AMSEL_R       EQU 0x40065528
GPIO_PORTP_PCTL_R        EQU 0x4006552C
GPIO_PORTP_ADCCTL_R      EQU 0x40065530
GPIO_PORTP_DMACTL_R      EQU 0x40065534
GPIO_PORTP_SI_R          EQU 0x40065538
GPIO_PORTP_DR12R_R       EQU 0x4006553C
GPIO_PORTP_WAKEPEN_R     EQU 0x40065540
GPIO_PORTP_WAKELVL_R     EQU 0x40065544
GPIO_PORTP_WAKESTAT_R    EQU 0x40065548
GPIO_PORTP_PP_R          EQU 0x40065FC0
GPIO_PORTP_PC_R          EQU 0x40065FC4
GPIO_PORTP               	EQU    2_010000000000000	

;//*****************************************************************************
;//
;//GPIO registers (PORTQ)
;//
;//*****************************************************************************
GPIO_PORTQ_DATA_BITS_R  EQU 0x40066000
GPIO_PORTQ_DATA_R       EQU 0x400663FC
GPIO_PORTQ_DIR_R        EQU 0x40066400
GPIO_PORTQ_IS_R         EQU 0x40066404
GPIO_PORTQ_IBE_R        EQU 0x40066408
GPIO_PORTQ_IEV_R        EQU 0x4006640C
GPIO_PORTQ_IM_R         EQU 0x40066410
GPIO_PORTQ_RIS_R        EQU 0x40066414
GPIO_PORTQ_MIS_R        EQU 0x40066418
GPIO_PORTQ_ICR_R        EQU 0x4006641C
GPIO_PORTQ_AFSEL_R      EQU 0x40066420
GPIO_PORTQ_DR2R_R       EQU 0x40066500
GPIO_PORTQ_DR4R_R       EQU 0x40066504
GPIO_PORTQ_DR8R_R       EQU 0x40066508
GPIO_PORTQ_ODR_R        EQU 0x4006650C
GPIO_PORTQ_PUR_R        EQU 0x40066510
GPIO_PORTQ_PDR_R        EQU 0x40066514
GPIO_PORTQ_SLR_R        EQU 0x40066518
GPIO_PORTQ_DEN_R        EQU 0x4006651C
GPIO_PORTQ_LOCK_R       EQU 0x40066520
GPIO_PORTQ_CR_R         EQU 0x40066524
GPIO_PORTQ_AMSEL_R      EQU 0x40066528
GPIO_PORTQ_PCTL_R       EQU 0x4006652C
GPIO_PORTQ_ADCCTL_R     EQU 0x40066530
GPIO_PORTQ_DMACTL_R     EQU 0x40066534
GPIO_PORTQ_SI_R         EQU 0x40066538
GPIO_PORTQ_DR12R_R      EQU 0x4006653C
GPIO_PORTQ_WAKEPEN_R    EQU 0x40066540
GPIO_PORTQ_WAKELVL_R    EQU 0x40066544
GPIO_PORTQ_WAKESTAT_R   EQU 0x40066548
GPIO_PORTQ_PP_R         EQU 0x40066FC0
GPIO_PORTQ_PC_R         EQU 0x40066FC
GPIO_PORTQ               	EQU    2_100000000000000	

;//*****************************************************************************
;//
;//GPIO registers (PORTB AHB)
;//
;//*****************************************************************************
GPIO_PORTB_AHB_DATA_BITS_R  EQU 0x40059000
GPIO_PORTB_AHB_DATA_R   EQU 0x400593FC
GPIO_PORTB_AHB_DIR_R    EQU 0x40059400
GPIO_PORTB_AHB_IS_R     EQU 0x40059404
GPIO_PORTB_AHB_IBE_R    EQU 0x40059408
GPIO_PORTB_AHB_IEV_R    EQU 0x4005940C
GPIO_PORTB_AHB_IM_R     EQU 0x40059410
GPIO_PORTB_AHB_RIS_R    EQU 0x40059414
GPIO_PORTB_AHB_MIS_R    EQU 0x40059418
GPIO_PORTB_AHB_ICR_R    EQU 0x4005941C
GPIO_PORTB_AHB_AFSEL_R  EQU 0x40059420
GPIO_PORTB_AHB_DR2R_R   EQU 0x40059500
GPIO_PORTB_AHB_DR4R_R   EQU 0x40059504
GPIO_PORTB_AHB_DR8R_R   EQU 0x40059508
GPIO_PORTB_AHB_ODR_R    EQU 0x4005950C
GPIO_PORTB_AHB_PUR_R    EQU 0x40059510
GPIO_PORTB_AHB_PDR_R    EQU 0x40059514
GPIO_PORTB_AHB_SLR_R    EQU 0x40059518
GPIO_PORTB_AHB_DEN_R    EQU 0x4005951C
GPIO_PORTB_AHB_LOCK_R   EQU 0x40059520
GPIO_PORTB_AHB_CR_R     EQU 0x40059524
GPIO_PORTB_AHB_AMSEL_R  EQU 0x40059528
GPIO_PORTB_AHB_PCTL_R   EQU 0x4005952C
GPIO_PORTB_AHB_ADCCTL_R EQU 0x40059530
GPIO_PORTB_AHB_DMACTL_R EQU 0x40059534
GPIO_PORTB_AHB_SI_R     EQU 0x40059538
GPIO_PORTB_AHB_DR12R_R  EQU 0x4005953C
GPIO_PORTB_AHB_WAKEPEN_R       EQU 0x40059540
GPIO_PORTB_AHB_WAKELVL_R   EQU 0x40059544
GPIO_PORTB_AHB_WAKESTAT_R  EQU 0x40059548
GPIO_PORTB_AHB_PP_R     EQU 0x40059FC0
GPIO_PORTB_AHB_PC_R     EQU 0x40059FC4
GPIO_PORTB               	EQU    2_000000000000010	



; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamarGPIO_Init de outro arquivo
		; ****************************************
		; Exportar as funções usadas em outros arquivos
		; ****************************************
		EXPORT PortJ_Input
		EXPORT Port_Output
		EXPORT PortA_Output
		EXPORT PortP_Output
		EXPORT PortQ_Output
		EXPORT PortB_Output
;--------------------------------------------------------------------------------
; FunçãoGPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Escrever função de inicialização dosGPIO
; Inicializar todas as portas utilizadas.
; ****************************************
; Precisamos fazer um o passo a passo que o prof colocou no vídeo deGPIO
; 1. Setar os bits das portas no RCGCPIO e habiliar o clock de cada porta
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endereço do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTN                 ;Seta o bit da porta N
			ORR     R1, #GPIO_PORTJ					;Seta o bit da porta J, fazendo com OR
			ORR		R1, #GPIO_PORTF					;Seta o bit da porta F, fazendo com OR
			ORR		R1, #GPIO_PORTA
			ORR		R1, #GPIO_PORTB
			ORR		R1, #GPIO_PORTQ
			ORR		R1, #GPIO_PORTP
            STR     R1, [R0]						;Armazena na memória os bits do registrador RCGCGPIO

; 2. Verificar no PRGPIO se a porta está pronta para uso
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endereço do PRGPIO pra checar se os bits já foram setados
CheckGPIO	LDR     R1, [R0]						;Carrega da memória o conteúdo do endereço do registrador
			MOV     R2, #GPIO_PORTN                 ;Seta os bits das portas para comparar
			ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, agora com OR para não sobrescrever
			ORR		R2, #GPIO_PORTF					;Seta o bit da porta F, agora com OR para não sobrescrever
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     CheckGPIO					    ;Se R1 != R2, Z vai receber 1, e o código volta para a branch
 
; 3. Zerar os bits das portas noGPIOAMSEL para desabilitar a entrada analógica
            MOV     R1, #0x00						;Zera o registrador para desabilitar a função analógica
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega R0 com o endereço do AMSEL para a porta J
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta J da memória
            LDR     R0, =GPIO_PORTN_AHB_AMSEL_R		;Carrega R0 com o endereço do AMSEL para a porta N
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta N da memória
			LDR     R0, =GPIO_PORTF_AHB_AMSEL_R		;Carrega R0 com o endereço do AMSEL para a porta F
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta F da memória
		
; 4. Zerar os bits das portas noGPIOPCTL, que desabilita o uso de funções alternativas
            MOV     R1, #0x00					    ;Zera o registrador para selecionar o modoGPIO
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega R0 com o endereço do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória
            LDR     R0, =GPIO_PORTN_AHB_PCTL_R      ;Carrega R0 com o endereço do PCTL para a porta N
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da memória
			LDR     R0, =GPIO_PORTF_AHB_PCTL_R      ;Carrega R0 com o endereço do PCTL para a porta F
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta F da memória
		
 
			
; 5. Zerar os bits das portas de entrada e setar as portas de saída noGPIODIR
            ; seta as saídas - F e N
			LDR     R0, =GPIO_PORTN_AHB_DIR_R		;Carrega R0 com o endereço doGPIODIR para a porta N
			MOV     R1, #2_00000011					;PN1 & PN0 para LED
            STR     R1, [R0]						;Guarda na porta N doGPIODIR o valor de R1
			LDR     R0, =GPIO_PORTF_AHB_DIR_R		;Carrega R0 com o endereço do DIR para a porta F
			MOV     R1, #2_00010001					;PF4 & PF0 para LED
            STR     R1, [R0]						;Guarda na porta F doGPIO o valor do R1
			LDR     R0, =GPIO_PORTA_AHB_DIR_R		;Carrega R0 com o endereço do AMSEL para a porta A
            MOV     R1, #2_11110000					    ;Guarda no registrador AMSEL da porta F da memória
			STR     R1, [R0]						;Guarda na porta F doGPIO o valor do R1
			LDR     R0, =GPIO_PORTB_AHB_DIR_R		;Carrega R0 com o endereço do AMSEL para a porta B
            MOV     R1, #2_00110000					    ;Guarda no registrador AMSEL da porta F da memória
            STR     R1, [R0]						;Guarda na porta F doGPIO o valor do R1
			LDR     R0, =GPIO_PORTP_DIR_R		;Carrega R0 com o endereço do AMSEL para a porta B
            MOV     R1, #2_00100000					    ;Guarda no registrador AMSEL da porta F da memória
            STR     R1, [R0]						;Guarda na porta F doGPIO o valor do R1
			LDR     R0, =GPIO_PORTQ_DIR_R		;Carrega R0 com o endereço do AMSEL para a porta B
            MOV     R1, #2_00001111				    ;Guarda no registrador AMSEL da porta F da memória
            STR     R1, [R0]

 
			; zera a entrada J 
			LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega R0 com o endereço doGPIODIR para a porta J
            MOV     R1, #0x00               		;Colocar no registradorGPIODIR para funcionar como saída
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da memória
			
; 6. Zerar os bits AFSEL ;    
            MOV     R1, #0x00						;Colocar o valor 0 para não setar função alternativa
            LDR     R0, =GPIO_PORTN_AHB_AFSEL_R		;Carrega o endereço do AFSEL da porta N
            STR     R1, [R0]						;Desabilita o AFSEL na porta N
            LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
            STR     R1, [R0]                        ;Desabilita o AFSEL na porta J
			LDR     R0, =GPIO_PORTF_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta F
            STR     R1, [R0]                        ;Desabilita o AFSEL na porta F
			LDR     R0, =GPIO_PORTA_AHB_AFSEL_R		;Carrega R0 com o endereço do AMSEL para a porta A
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta F da memória
			LDR     R0, =GPIO_PORTB_AHB_AFSEL_R		;Carrega R0 com o endereço do AMSEL para a porta B
            STR     R1, [R0]					    ;Guarda no registrador AMSEL da porta F da memória
 
			
; 7. Setar os bits deGPIODEN para habilitar a função digital	
			
            LDR     R0, =GPIO_PORTN_AHB_DEN_R			;Carrega o endereço do DEN
            MOV     R1, #2_00000011                     ;Seta os pinos PN0 e PN1 
            STR     R1, [R0]							;Armazena no registrador da memória funcionalidade digital 
			
			LDR     R0, =GPIO_PORTF_AHB_DEN_R			;Carrega o endereço do DEN
            MOV     R1, #2_00010001                     ;Seta os pinos PF0 e PF4
            STR     R1, [R0]							;Armazena no registrador da memória funcionalidade digital 
 
            LDR     R0, =GPIO_PORTA_AHB_DEN_R		;Carrega R0 com o endereço do AMSEL para a porta A
            MOV     R1, #2_11110000;Guarda no registrador AMSEL da porta F da memória
			STR     R1, [R0]						;Guarda na porta F doGPIO o valor do R1
			
			LDR     R0, =GPIO_PORTB_AHB_DEN_R		;Carrega R0 com o endereço do AMSEL para a porta B
            MOV     R1, #2_00110000					    ;Guarda no registrador AMSEL da porta F da memória
            STR     R1, [R0]

			LDR     R0, =GPIO_PORTP_DEN_R		;Carrega R0 com o endereço do AMSEL para a porta B
            MOV     R1, #2_00100000					    ;Guarda no registrador AMSEL da porta F da memória
            STR     R1, [R0]
			
			LDR     R0, =GPIO_PORTQ_DEN_R		;Carrega R0 com o endereço do AMSEL para a porta B
            MOV     R1, #2_00001111					    ;Guarda no registrador AMSEL da porta F da memória
            STR     R1, [R0]
			
			LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endereço do DEN
			MOV     R1, #2_00000011                     ;Seta os pinos PJ0 e PJ1   
            STR     R1, [R0]                            ;Armazena no registrador da memória funcionalidade digital
			
			
; 8. Habilitar resistor de pullUp interno
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endereço do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
            STR     R1, [R0]							;Armazena no registrador da memória do resistor de pull-up
            
;retorna            
			BX      LR

; ---------------------------------------------------------------------------------------------------------------------
Port_Output
	LDR	R1, =GPIO_PORTN_AHB_DATA_R		    ;Carrega o valor do offset da porta N
	LDR R2, [R1]							;Carrega o valor da porta N em R2
	BIC R2, #2_00000011                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11111100
	ORR R3, R2, R0, LSR #2                  ;Os últimos 2 bits de R0 são da porta F, não usamos aqui
	STR R3, [R1]                        	;Armazena o resultado na porta    

	LDR	R1, =GPIO_PORTF_AHB_DATA_R		    ;Carrega o valor do offset da porta F
	LDR R2, [R1]							;Carrega o valor da porta F em R2
	BIC R2, #2_00010001                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2
	AND R0, R0, #2_00010001
	ORR R3, R0, R2                          ;Fazer o OR do valor lido pela porta com o parâmetro de entrada
	STR R3, [R1]                            ;Escreve na porta F o barramento de dados dos pinos F4 e F0
	
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset da porta F
	LDR R2, [R1]							;Carrega o valor da porta F em R2
	BIC R2, #2_00010001                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2
	AND R0, R0, #2_00010001
	
	BX LR									;Retorna
	
PortB_Output
	LDR	R1, =GPIO_PORTB_AHB_DATA_R		    ;Carrega o valor do offset da porta F
	LDR R2, [R1]							;Carrega o valor da porta F em R2
	BIC R2, #2_00110000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2
	AND R0, R0, #2_00110000
	STR R0, [R1]                            ;Escreve na porta N o barramentode dados do pino N1
	BX LR		

PortA_Output
	LDR	R1, =GPIO_PORTA_AHB_DATA_R		    ;Carrega o valor do offset da porta F
	AND R0, R0, #2_11110000
	STR R0, [R1]                            ;Escreve na porta N o barramentode dados do pino N1
	BX LR									;Retorna
	
PortQ_Output
	LDR	R1, =GPIO_PORTQ_DATA_R		    ;Carrega o valor do offset da porta F
	AND R0, R0, #2_00001111
	STR R0, [R1]                            ;Escreve na porta N o barramentode dados do pino N1
	BX LR									;Retorna	

PortP_Output
	LDR	R1, =GPIO_PORTP_DATA_R			;Carrega o valor do offset da porta F
	LDR R2, [R1]							;Carrega o valor da porta F em R2
	BIC R2, #2_00100000                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2
	AND R0, R0, #2_00100000
	STR R0, [R1]                            ;Escreve na porta N o barramentode dados do pino N1
	BX LR									;Retorna

; -------------------------------------------------------------------------------
; Essa função retorna o valor lido na porta J
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;Faz a leitura do barramento de dados dos pinos [J1-J0]
	BX LR

    ALIGN                           ;Garante que o fim da seção está alinhada 
    END                             ; fim do arquivo