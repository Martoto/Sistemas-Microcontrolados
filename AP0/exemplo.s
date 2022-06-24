; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>

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

; -------------------------------------------------------------------------------
; Fun��o main()
PRIMOS EQU 0x20000A00
LIST EQU 0x20000B00 
IN_N EQU 20
	
	
Start  
; Comece o c�digo aqui <======================================================
	LDR 	R2, =LIST 							; posi��o lista sa�da
	LDR		R0, =entrada      					; carrega entrada na memoria
	MOV		R3, #0								; contador - �ndice da lista
												; loop para inserir a lista a partir da posi��o de mem�ria em LIST
insertLoop	
	LDRB	R1, [R0], #1
	STRB	R1, [R2], #1
	ADD		R3, #1
	CMP		R3, #IN_N
	BNE insertLoop
			
			
			
	MOV		R12, R2								; guarda o endere�o final da lista armazenada pra comparar depois
	SUB		R12, #1		
	
	LDR		R1, =PRIMOS							; local da mem�ria onde vai ficar os nro primos
	LDR 	R0, =LIST 							; posi��o lista nros aleatorios
	
	MOV 	R8, #0								; contador para nros primos
	MOV R7, #0	;Incremento do while externo (pra saber quando terminou de varrer
	
loop			;while externo - come�a com 2 e vai at� o n�mero
	MOV R3, #2
	
primo
	
	;Resetar o carry
	MOV R11, #1
	CMP R11, #2
	LDRB R4, [R0]	;Le da memoria o R0 e salva em R4
	CMP R3, R4		;Compara R3 com R4 (R3-R4) ->
	
	ITTE CC						;if R3 < R4
		UDIVCC R5, R4, R3		;Divide R4 por R3
		MLSCC R6, R3, R5, R4 	;R6 � o resto da divis�o
		BCS foundPrime			;se R3 >= R4 ent�o chegou no R4
								;ent�o � primo
								
	CMP R6, #0				;compara o resto com 0
	ITT NE 					;se resto != 0, pode ser primo	
		ADDNE R3, R3, #1	;se for diferente, incrementa R3 
		BNE primo			;volta pro loop de teste de primo
	BEQ notPrime		;se o resto = 0 ent�o n�o � primo
	
foundPrime				;se for primo
	
	ADD R8, R8, #1 		;Incrementa o tamanho do vetor ordenado de primos
	STRB R4, [R1], #1	;Salva o R4 em R1 e soma 8 em R1 pra ir pro pr�ximo slot de mem�ria
	ADD R0, R0, #1	;Soma 8 no R0 p/ ir pro pr�x num do vetor aleat�rio
	
	ADD R7, R7, #1		;Incrementa R7 pra avan�ar 1 no while
	CMP R7, #IN_N			;Compara R7 com o vetor aleat�rio p/ saber se acabou de varrer o vetor
	
	BCC loop				;se for menor, volta pro loop
	BCS bubblesort		;se for maior ou igual, vai pro sort

notPrime				;se n�o for primo
	ADD R0, R0, #1			;incrementa o R0 pra ir pro pr�ximo n�mero do vetor aleat�rio
	
	ADD R7, R7, #1			;incrementa R7 pra avan�ar 1 no while
	CMP R7, #IN_N				;compara R7 com o vetor aleat�rio p/ saber se acabou de varrer o vetor
	
	BCC loop				;se n�o acabou, volta pro loop
	BCS bubblesort		;se acabou, vai pro sort
	

	
bubblesort
	LDR 	R0, =PRIMOS
	MOV 	R6, #0									; Registrador que far� o papel de troca=0 para sair do loop
	MOV 	R9, #1
comp
	LDRB 	R1, [R0]								; carrega i em R1
	LDRB 	R2, [R0,#1]								; carrega i+1 em R2
	CMP 	R1,R2									; compara i e i+1
	BLHI	troca_pos								    ; se i > i+1, troca de posi��o
	ADD		R0, R0, #1									; incrementa o endere�o
	ADD 	R9, R9, #1								; iterador bubble
	CMP 	R9,R8									; verifica se chegou ao final da lista
	BCC 	comp									; se n�o chegou ao final da lista, continua verificando a lista
	CMP 	R6,#1
	BEQ 	bubblesort
	B		fim
	
troca_pos
	STRB 	R2,[R0]
	STRB 	R1,[R0, #1]
	MOV 	R6, #1
	BX 	LR

fim 
	NOP
entrada		DCB		193, 63, 176, 127, 43, 13, 211, 3, 203, 5, 21, 7, 206, 245, 157, 237, 241, 105, 252, 19
	NOP
    ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo
