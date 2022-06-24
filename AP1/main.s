; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este � um projeto template.


; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Defini��es de Valores


; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms			
		; ****************************************
		; Importar as fun��es declaradas em outros arquivos
		; ****************************************
		IMPORT  GPIO_Init
		IMPORT 	PortJ_Input
		IMPORT 	Port_Output
		IMPORT 	PortA_Output
		IMPORT 	PortP_Output
		IMPORT  PortQ_Output
		IMPORT PortB_Output

; -------------------------------------------------------------------------------
; Fun��o main()

DIGITO_0	EQU	2_00111111
DIGITO_1	EQU	2_00000110
DIGITO_2	EQU	2_01011011
DIGITO_3	EQU	2_01001111
DIGITO_4	EQU	2_01100110
DIGITO_5	EQU	2_01101101
DIGITO_6	EQU	2_01111101
DIGITO_7	EQU	2_00000111
DIGITO_8	EQU	2_01111111
DIGITO_9	EQU	2_01100111
TICKS		EQU 30
	
	
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
; ****************************************
; Fazer as demais inicializa��es aqui.
; ****************************************
	MOV R4, #2_00000001 	; primeira posi��o da opera��o passeio do cavaleiro
	MOV R5, #1	
	MOV R6, #0 				;unidade da contagem
	MOV R10, #0 			;dezena da contagem

; dire��o da opera��o passeio do cavaleiro -> direita = 0, esquerda = 1
	MOV R9, #1				; conta passo atual
	MOV R7, #0				; contador display
	MOV R8, #0				;tick
	MOV R11, #0				; buttonDown

MainLoop
; ****************************************
; Escrever c�digo o loop principal aqui. 
; ****************************************

;			MOV	R0, R8					
;			PUSH {LR}				
;			BL SysTick_Wait1ms
;			POP {LR}

			BL verificaBotoes
			BL acendeLeds
			BL acendeDisplay
			BL contador
			B MainLoop

verificaBotoes
			PUSH {LR}
			BL PortJ_Input
			POP {LR}
			
			CMP R11, #0
			IT EQ
				BEQ minStep
			
			CMP R9, #10
			BEQ maxStep
			CMP R0, #2_00000010			; verifica se o passo ainda n�o atingiu 9
			IT EQ						; se sim					
				ADDEQ R9, #1			; Adiciona um ao passo 
				MOVEQ R11, #0
maxStep

			CMP R9, #1
			BEQ minStep
			CMP R0, #2_00000001			; verifica se o passo ainda n�o atingiu 1
			IT EQ						; se sim			
				SUBEQ R9, #1			; Subtrai um ao passo 
				MOVEQ R11, #0
			
minStep

			CMP R0, #3
			IT EQ
				MOVEQ R11, #1
			
			
			BX LR

	
acendeLeds
			PUSH {LR}
			MOV R0, R4						; carrega para R0 a posi��o inicial do modo passeio do cavaleiro
			BL PortA_Output
			MOV R0, R4						; carrega para R0 a posi��o inicial do modo passeio do cavaleiro
			BL PortQ_Output
			MOV R0, #2_00100000
			BL PortP_Output
			
			BL waitTransistor

			
			MOV R0, #2_00000000
			BL PortP_Output
			POP {LR}
			
			BX LR
			
			
acendeDisplay
  		MOV R3, #10
		MOV R6, #0;
		UDIV R10, R7, R3		;Divide R7 por R3, R10 � casa decimal
		MLS R6, R3, R10, R7 	;R6 � o resto da divis�o, casa unidade
		
			
			
		PUSH{LR}
		BL pegaDigito
		BL carregaUnidade
		MOV R6, R10
		BL pegaDigito
		BL carregaDezena
		BL waitTransistor
		POP{LR}
		BX LR


carregaUnidade
	PUSH{LR}
			MOV R0, R6						
			BL PortA_Output
		
			MOV R0, R6						
			BL PortQ_Output
			
			MOV R0, #2_00100000
			BL PortB_Output
			BL waitTransistor
			MOV R0, #2_00000000
			BL PortB_Output
	POP{LR}
	BX LR
	
carregaDezena
	PUSH{LR}
			MOV R0, R6						
			BL PortA_Output
		
			MOV R0, R6						
			BL PortQ_Output
			
			MOV R0, #2_00010000
			BL PortB_Output
			BL waitTransistor
			MOV R0, #2_00000000
			BL PortB_Output
	POP{LR}
	BX LR
			
contador			

		CMP R8, #TICKS
			MOVEQ R8, #0
			ADDNE R8, #1
			BXNE LR
		
		ADD R7, R9					; Incrementa o contador 
		CMP R7, #99					; Verifica se j� chegou em 99
		IT CS						; Se chegou
			MOVCS R7, #0			; Zera o contador
			
			
		; Passeio do Cavaleiro
		CMP R5, #0
		ITE EQ
		LSREQ R4, #1
		LSLNE R4, #1

		CMP R4, #2_00000001			; Verifica se o cavaleiro j� chegou ao �ltimo led da direita
		IT EQ						; se chegou
		MOVEQ R5, #1				; altera a dire��o - vai pra esquerda

		CMP R4, #2_10000000			; Verifica se o cavaleiro j� chegou ao �ltimo led da esquerda	
		IT EQ						; se chegou
		MOVEQ R5, #0				; altera a dire��o - vai pra direita
						
		BX LR
			
waitTransistor
		MOV	R0, #3					; carrega a velocidade para o R0 -- que � o registrador que a fun��o SysTick_Wait1ms puxa
		PUSH {LR}				
		BL SysTick_Wait1ms
		POP {LR}
		BX LR
		
pegaDigito
	CMP R6, #0
	ITT EQ
		LDREQ R6, =DIGITO_0
		BXEQ LR
	CMP R6, #1
	ITT EQ
		LDREQ R6, =DIGITO_1
		BXEQ LR
	CMP R6, #2
	ITT EQ
		LDREQ R6, =DIGITO_2
		BXEQ LR
	CMP R6, #3
	ITT EQ
		LDREQ R6, =DIGITO_3
		BXEQ LR
	CMP R6, #4
	ITT EQ
		LDREQ R6, =DIGITO_4
		BXEQ LR
	CMP R6, #5
	ITT EQ
		LDREQ R6, =DIGITO_5
		BXEQ LR
	CMP R6, #6
	ITT EQ
		LDREQ R6, =DIGITO_6
		BXEQ LR
	CMP R6, #7
	ITT EQ
		LDREQ R6, =DIGITO_7
		BXEQ LR
	CMP R6, #8
	ITT EQ
		LDREQ R6, =DIGITO_8
		BXEQ LR
	CMP R6, #9
	IT EQ
		LDREQ R6, =DIGITO_9
	BX LR
				


; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
