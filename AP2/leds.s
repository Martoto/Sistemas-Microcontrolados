; leds.s
; Desenvolvido para a placa EK-TM4C1294XL
; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT PiscaLed
        IMPORT PortP_Output
        IMPORT SysTick_Wait1ms
        IMPORT PortA_Output
        IMPORT PortQ_Output
        IMPORT PortP_Output

;--------------------------------------------------------------------------------
; Acende 1 led
; Parâmetro de entrada: R0 o número do led que será aceso em one-hot
; Parâmetro de saída: Não tem
; Modifica: R0
AcendeLed
    ; 0 = PQ0 PQ1 PQ2 PQ3 PA4 PA5
    ; 0 = a   b   c   d   e   f
	PUSH {R1, R3, LR}
    MOV R3, R0                  ; guarda o valor da entrada

    AND R0, R3, #2_00001111     ; R0 = os bits para porta Q
	BL PortQ_Output			    ; Acende leds na porta Q

    AND R0, R3, #2_11110000     ; R0 = os bits para porta A
	BL PortA_Output			    ; Acende leds na porta A

    MOV R0, #2_100000           ; PP5
	BL PortP_Output			    ; Habilita os Leds
	MOV R0, #1                  ; Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms

	MOV R0, #5                  ; Chamar a rotina para esperar 5ms
	BL SysTick_Wait1ms

    MOV R0, #0x00                
	BL PortP_Output			    ; Desabilita os Leds
	MOV R0, #1                  ; Chamar a rotina para esperar 1ms
	BL SysTick_Wait1ms

	POP {R1, R3, LR}
	BX LR						 ;return
	
;--------------------------------------------------------------------------------
; Acende todos os leds simultaneamente por 5 vezes com intervalo de 0,5 em 0,5 s
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
; Modifica: R0
PiscaLed
    ; 0 = PQ0 PQ1 PQ2 PQ3 PA4 PA5
    ; 0 = a   b   c   d   e   f
	PUSH {R0, R4, LR}
	MOV R4, #5					; Contador do número de vezes que pisca
Loop5x
    MOV R0, #2_11111111			; Seta R0 para acender todos os leds
	BL AcendeLed				; Chama a função que acende os leds
	MOV R0, #500				; Espera 0,5s 
	BL SysTick_Wait1ms
	SUB R4, #1
	CMP R4, #0					; Piscou 5 vezes?
	BNE Loop5x
	
	POP {R0, R4, LR}
	BX LR						 ;return


; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
