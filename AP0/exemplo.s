; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM		

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>

; -------------------------------------------------------------------------------
; Função main()
PRIMOS EQU 0x20000A00
LIST EQU 0x20000B00 
IN_N EQU 20
	
	
Start  
; Comece o código aqui <======================================================
	LDR 	R2, =LIST 							; posição lista saída
	LDR		R0, =entrada      					; carrega entrada na memoria
	MOV		R3, #0								; contador - índice da lista
												; loop para inserir a lista a partir da posição de memória em LIST
insertLoop	
	LDRB	R1, [R0], #1
	STRB	R1, [R2], #1
	ADD		R3, #1
	CMP		R3, #IN_N
	BNE insertLoop
			
			
			
	MOV		R12, R2								; guarda o endereço final da lista armazenada pra comparar depois
	SUB		R12, #1		
	
	LDR		R1, =PRIMOS							; local da memória onde vai ficar os nro primos
	LDR 	R0, =LIST 							; posição lista nros aleatorios
	
	MOV 	R8, #0								; contador para nros primos
	MOV R7, #0	;Incremento do while externo (pra saber quando terminou de varrer
	
loop			;while externo - começa com 2 e vai até o número
	MOV R3, #2
	
primo
	
	;Resetar o carry
	MOV R11, #1
	CMP R11, #2
	LDRB R4, [R0]	;Le da memoria o R0 e salva em R4
	CMP R3, R4		;Compara R3 com R4 (R3-R4) ->
	
	ITTE CC						;if R3 < R4
		UDIVCC R5, R4, R3		;Divide R4 por R3
		MLSCC R6, R3, R5, R4 	;R6 é o resto da divisão
		BCS foundPrime			;se R3 >= R4 então chegou no R4
								;então é primo
								
	CMP R6, #0				;compara o resto com 0
	ITT NE 					;se resto != 0, pode ser primo	
		ADDNE R3, R3, #1	;se for diferente, incrementa R3 
		BNE primo			;volta pro loop de teste de primo
	BEQ notPrime		;se o resto = 0 então não é primo
	
foundPrime				;se for primo
	
	ADD R8, R8, #1 		;Incrementa o tamanho do vetor ordenado de primos
	STRB R4, [R1], #1	;Salva o R4 em R1 e soma 8 em R1 pra ir pro próximo slot de memória
	ADD R0, R0, #1	;Soma 8 no R0 p/ ir pro próx num do vetor aleatório
	
	ADD R7, R7, #1		;Incrementa R7 pra avançar 1 no while
	CMP R7, #IN_N			;Compara R7 com o vetor aleatório p/ saber se acabou de varrer o vetor
	
	BCC loop				;se for menor, volta pro loop
	BCS bubblesort		;se for maior ou igual, vai pro sort

notPrime				;se não for primo
	ADD R0, R0, #1			;incrementa o R0 pra ir pro próximo número do vetor aleatório
	
	ADD R7, R7, #1			;incrementa R7 pra avançar 1 no while
	CMP R7, #IN_N				;compara R7 com o vetor aleatório p/ saber se acabou de varrer o vetor
	
	BCC loop				;se não acabou, volta pro loop
	BCS bubblesort		;se acabou, vai pro sort
	

	
bubblesort
	LDR 	R0, =PRIMOS
	MOV 	R6, #0									; Registrador que fará o papel de troca=0 para sair do loop
	MOV 	R9, #1
comp
	LDRB 	R1, [R0]								; carrega i em R1
	LDRB 	R2, [R0,#1]								; carrega i+1 em R2
	CMP 	R1,R2									; compara i e i+1
	BLHI	troca_pos								    ; se i > i+1, troca de posição
	ADD		R0, R0, #1									; incrementa o endereço
	ADD 	R9, R9, #1								; iterador bubble
	CMP 	R9,R8									; verifica se chegou ao final da lista
	BCC 	comp									; se não chegou ao final da lista, continua verificando a lista
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
    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo
