; teclado.s
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
        IMPORT PortL_Input
        IMPORT PortM_ConfigDir
        EXPORT Verificar_Teclado


Verificar_Teclado
    PUSH {LR}

    MOV R0, #2_00010000               ; Configura PM4 como saida e PM5, PM6 e PM7 como entrada
    BL PortM_ConfigDir                ; Configura Entradas e Saidas para porta M

    MOV R0, #2_0001                   ; Verifica Tecla 1
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #1                    ; Retorna R0 = 1
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_0010                   ; Verifica Tecla 4
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #4                    ; Retorna R0 = 4
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_0100                   ; Verifica Tecla 7
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #7                    ; Retorna R0 = 7
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_00100000               ; Configura PM5 como saida e PM4, PM6 e PM7 como entrada
    BL PortM_ConfigDir                ; Configura Entradas e Saidas para porta M

    MOV R0, #2_0001                   ; Verifica Tecla 2
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #2                    ; Retorna R0 = 2
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_0010                   ; Verifica Tecla 5
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #5                    ; Retorna R0 = 5
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_0100                   ; Verifica Tecla 8
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #8                    ; Retorna R0 = 8
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_1000                   ; Verifica Tecla 0
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #0                    ; Retorna R0 = 0
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_01000000               ; Configura PM6 como saida e PM4, PM5 e PM7 como entrada
    BL PortM_ConfigDir                ; Configura Entradas e Saidas para porta M

    MOV R0, #2_0001                   ; Verifica Tecla 3
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #3                    ; Retorna R0 = 3
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_0010                   ; Verifica Tecla 6
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #6                    ; Retorna R0 = 6
      BEQ end_Verificar_Teclado       ; Retorna

    MOV R0, #2_0100                   ; Verifica Tecla 9
    BL VerificaTecla                  ; Verifica se a tecla foi precionada com debouncing
    CMP R0, #1                        ; Retornan R0 = 1 se a tecla foi precionada
    ITT EQ                            ; Se a tecla foi precionada
      MOVEQ R0, #9                    ; Retorna R0 = 9
      BEQ end_Verificar_Teclado       ; Retorna
    
    MOV R0, #10                       ; Retorna R0 = 10 quando nenhuma tecla foi precionada
end_Verificar_Teclado
    POP {PC}



VerificaTecla
    PUSH {LR}
    MOV R3, R0
    MOV R2, #0                        ; Contador debouncing

verifica_tecla_loop
    BL PortL_Input                    ; Obtem os dados da entrada L
    TST R0, R3                        ; Testa se PLx = 0
    ITEE EQ                           ; Se PL0 = 0
        ADDEQ R2, #1                  ; Se igual, incrementa o contador
        MOVNE R0, #0                  ; Se não, R0 = 0 e retorna
        BNE end_verifica_tecla
    
    MOV R0, #1
    BL SysTick_Wait1ms

    CMP R2, #20                       ; Verifica se o contador = 20
    BLT verifica_tecla_loop           ; Se contador menor que 20, continua o loop

    MOV R0, #1                        ; Retorna R0 = 1
end_verifica_tecla
    POP {PC}
     
; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
