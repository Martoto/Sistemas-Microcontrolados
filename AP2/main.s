; main.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
    
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
    AREA  DATA, ALIGN=2
    ; Se alguma variável for chamada em outro arquivo
    ;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
                                       ; partir de outro arquivo
;<var>  SPACE <tam>                        ; Declara uma variável de nome <var>
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
    IMPORT  PLL_Init
    IMPORT  SysTick_Init
    IMPORT  SysTick_Wait1ms   
	IMPORT SysTick_Wait1us
	IMPORT PortA_Output
    IMPORT PortQ_Output
    IMPORT PortP_Output
		
    IMPORT  GPIO_Init
    IMPORT  PortJ_Init 
    IMPORT Verificar_Teclado
	IMPORT PortM_Output
    IMPORT PortK_Output
    EXPORT Zerar_Tabuadas
	EXPORT LCD_init
    EXPORT ImprimeTabuadaLcd
    EXPORT Print_InitMsg

init_str      DCB  "Deus é \0"
init_str2     DCB  "fiel\0\0"
tabuadado_str DCB  "-> \0"

; -------------------------------------------------------------------------------
contadores EQU 0x20000000     ; Posição dos contadores armazenados na RAM

; Função main()
Start      
    BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
    BL SysTick_Init
    BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
    BL LCD_init
    BL PortJ_Init
    BL Zerar_Tabuadas

MainLoop
    BL Verificar_Teclado

    CMP R0, #10
    BEQ MainLoop            ; Não faz nada até uma tecla ser precionada

    LDR  R1,=contadores     ; Coloca o endereço dos contadores em R1
    LDRB R1, [R1, R0]       ; Lê o contador do número pressionado
    MUL  R2, R0, R1         ; R2 = R0 * R1

    BL ImprimeTabuadaLcd    ; Imprime no LCD

    CMP R1, #9              ; Verifica se o contador resetou
    BLEQ PiscaLed

    BL Aumenta_cont         ; Aumente o contador do número pressionado

    MOV R0, #300            ; Espera 300ms para entre cada tecla
    BL SysTick_Wait1ms

    B MainLoop              ; Volta para o laço principal



Aumenta_cont
    LDR R1, =contadores    ; Coloca o endereço dos contadores em R1
    LDRB R2, [R1, R0]      ; Lê o valor que do contador para R2
    CMP R2, #9             ; Vê se o valor é máximo
    ITE EQ
        MOVEQ  R2, #0      ; Se for 9, Zera o contador
        ADDNE  R2, #1      ; Se não, Incrementa o contador
    STRB R2, [R1, R0]          ; Escreve o contador na memória
    BX LR
  
Zerar_Tabuadas
    PUSH {R0, R1, LR}
    LDR  R0, =contadores   ; Coloca o endereço dos contadores em R0
    MOV  R1, #0
    STR  R1, [R0], #4      ; [R0] = R2 e R0 += 4   ->> zera 4 bytes
    STR  R1, [R0], #4      ; [R0] = R2 e R0 += 4   ->> zera 4 bytes
    STRH R1, [R0]          ; [R0] = R2 e R0 += 2   ->> zera 2 bytes
    BL Print_InitMsg
    POP {R0, R1, LR}
    BX LR
	
	
	


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
	

PiscaLed
    ; 0 = PQ0 PQ1 PQ2 PQ3 PA4 PA5
    ; 0 = a   b   c   d   e   f
	PUSH {R0, R4, LR}
	MOV R4, #5					; Contador do número de vezes que pisca
blink
    MOV R0, #2_11111111			; Seta R0 para acender todos os leds
	BL AcendeLed				; Chama a função que acende os leds
	MOV R0, #500				; Espera 0,5s 
	BL SysTick_Wait1ms
	SUB R4, #1
	CMP R4, #0					; Piscou 5 vezes?
	BNE blink
	
	POP {R0, R4, LR}
	BX LR						 ;return


; ---------------------------------------------------------------------------
; Fim do Arquivo
; ---------------------------------------------------------------------------  
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
