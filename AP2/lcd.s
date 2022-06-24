; lcd.s
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
        IMPORT SysTick_Wait1ms
		    IMPORT SysTick_Wait1us
        
        EXPORT LCD_init
        EXPORT ImprimeTabuadaLcd
        EXPORT Print_InitMsg

init_str      DCB  "Pressione uma\0"
init_str2     DCB  "tecla p/ iniciar\0\0"
tabuadado_str DCB  "Tabuada do \0"

;--------------------------------------------------------------------------------
; Inicia o lcd
LCD_init
  PUSH {R0, R1, R2, R3, LR}

  MOV R0, #0x038            ; Inicia Configuracao do lcd, modo de 8 bits, 2 linhas
  MOV R1, #40               ; Esperar 40 us
  BL enviar_comando

  MOV R0, #0x06             ; Cursor com auto incremento para direita
  MOV R1, #40               ; Esperar 40 us
  BL enviar_comando

  MOV R0, #0xE              ; Inicia Configuracao do cursor, habilita cursor e display e cursor não pisca
  MOV R1, #40               ; Esperar 40 us
  BL enviar_comando
  
  POP {R0, R1, R2, R3, LR}
  BX LR



; -------------------------------------------------------------------------------------------------------------------------
; Exibe a mesagem inicial no lcd
Print_InitMsg
  PUSH {R0, R1, R2, R3, LR}

  MOV R0, #0x01             ; Reset
  LDR R1, =1640             ; Esperar 1640 us
  BL enviar_comando

  LDR R3, =init_str         ; print primeira frase
init_str_print
  LDRB R0, [R3], #1
  CMP R0, #0
  BEQ end_init_str_print
  BL enviar_dado
  B init_str_print
end_init_str_print

  MOV R0, #0xC0              ; Reset
  MOV R1, #40                ; Esperar 40 us
  BL enviar_comando

  LDR R3, =init_str2        ; print segunda frase
init_str_print2
  LDRB R0, [R3], #1
  CMP R0, #0
  BEQ end_init_str_print2
  BL enviar_dado
  B init_str_print2

end_init_str_print2
  POP {R0, R1, R2, R3, LR}
  BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Enviar_comando
; Entrada: R0 --> Comando enviado
;          R1 --> Tempo de espera
; Saída: Não tem
; Modifica: R0, R1, R2
enviar_comando
  PUSH {LR}
  PUSH {R1}                 ; Salva R1

  BL PortK_Output           ; Escreve na porta K o comando de R0
  MOV R0, #2_100            ; RS = 0, RW = 0, RE = 1
  BL PortM_Output           ; Escreve na porta M

  MOV R0, #10               ; Esperar 10 us
  BL SysTick_Wait1us

  MOV R0, #2_000            ; RS = 0, RW = 0, RE = 0
  BL PortM_Output           ; Escreve na porta M

  POP {R1}                  ; Recupera R1
  MOV R0, R1                ; Espera o tempo dado por R1
  BL SysTick_Wait1us

  POP {LR}
  BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Enviar_dado
; Entrada: R0 --> Dado enviado
; Saída: Não tem
; Modifica: R0, R1, R2
enviar_dado
  PUSH {LR}

  BL PortK_Output           ; Escreve na porta K o comando de R0
  MOV R0, #2_101            ; RS = 1, RW = 0, RE = 1
  BL PortM_Output           ; Escreve na porta M

  MOV R0, #10               ; Esperar 10 us
  BL SysTick_Wait1us

  MOV R0, #2_000            ; RS = 0, RW = 0, RE = 0
  BL PortM_Output           ; Escreve na porta M

  MOV R0, #40               ; Espera 40us
  BL SysTick_Wait1us

  POP {LR}
  BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Enviar_dado
; Entrada: R0 --> num
;          R1 --> count
;          R2 --> resultado
; Saída: Não tem
; Modifica: R0, R1, R2
ImprimeTabuadaLcd
  PUSH {R0, R1, R2, R3, R4, R5, LR}

  PUSH {R2} 
  PUSH {R1} 
  MOV R4, R0

  MOV R0, #0x01         ; Reset
  LDR R1, =1640         ; 1640us
  BL enviar_comando

  LDR R3, =tabuadado_str
tbd_print
  LDRB R0, [R3], #1
  CMP R0, #0
  BEQ end_tbd_print
  BL enviar_dado
  B tbd_print
end_tbd_print
  
  MOV R0, R4
  ADD R0, #'0'
  BL enviar_dado

  MOV R0, #':'
  BL enviar_dado

  mov r0, #0xc5               ; vai para o meio da segunda linha
  mov r1, #40
  bl enviar_comando

  MOV R0, R4
  ADD R0, #'0'
  BL enviar_dado

  MOV R0, #'x'
  BL enviar_dado

  POP {R0} 
  ADD R0, #'0'
  BL enviar_dado

  MOV R0, #'='
  BL enviar_dado

  POP {R0}
  MOV R1, #10                 
  UDIV R2, R0, R1             ; R2 = num/10
  MLS  R3, R2, R1, R0         ; R3 = num - R2*10

  CMP R2, #0x0 
  BEQ prox_digito
  MOV R0, R2
  ADD R0, #'0'
  BL enviar_dado

prox_digito
  MOV R0, R3
  ADD R0, #'0'
  BL enviar_dado

  mov r0, #0x0C               ; vai para o comeco da primeira linha
  mov r1, #40
  BL enviar_comando

  POP {R0, R1, R2, R3, R4, R5, LR}
  BX LR

; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
