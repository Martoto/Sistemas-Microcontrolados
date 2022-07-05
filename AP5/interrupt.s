


		AREA    |.text|, CODE, READONLY, ALIGN=2
	    THUMB                        ; Instruções do tipo Thumb-2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Interrupt            ; Permite chamar GPIO_Init de outro arquivo
		;EXPORT GPIOPortJ_Handler
			
Interrupt
	
		LDR R0, =0x40060410					; GPIO_PORTJ_AHB_IM_R
		LDR R1, [R0]
		BIC R1, R1, #2_00					; DESATIVA INTERRUPT NA PORTA J0
		STR R1, [R0]
		
		LDR R0, =0x40060404					; SETA A PORTAS J0 - GPIO_PORTJ_AHB_IS_R
		LDR R1, [R0]
		BIC R1, R1, #2_01
		STR R1, [R0]
		
		LDR R0, =0x40060408					; SETA 1 BORDA DE INTERRUPT PARA PORTA J0 - GPIO_PORTJ_AHB_IBE_R
		LDR R1, [R0]
		BIC R1, R1, #2_01
		STR R1, [R0]
		
		LDR R0, =0x4006040C					; SETA A PORTA J0 COMO BORDA DE DESCIDA - GPIO_PORTJ_AHB_IEV_R
		LDR R1, [R0]
		BIC R1, R1, #2_00
		ORR R1, R1, #2_00
		STR R1, [R0]
		
		LDR R0, =0x4006041C					; LIMPA INTERRUPTS DA PORTA J0 - GPIO_PORTJ_AHB_ICR_R
		LDR R1, [R0]
		ORR R1, R1, #2_01
		STR R1, [R0]
		
		LDR R0, =0x40060410					; ATIVA INTERRUPT NA PORTA J0- GPIO_PORTJ_AHB_IM_R
		LDR R1, [R0]
		ORR R1, R1, #2_01						
		STR R1, [R0]
		
		LDR R0, =0xE000E104        			; ATIVAR FONTE DE INTERRUPT NA PORTA J, EN1
        LDR R1, [R0]
		MOV R2, #1
        ORR R1, R1, R2, LSL#19
        STR R1, [R0]
		
		LDR R0, =0xE000E430					; SETA PRIORIDADE - NVIC_EN1_R, PRI12
		LDR R1, [R0]
		MOV R2, #3
		ORR R1, R1, R2, LSL#29
		STR R1, [R0]
		
		BX LR

		ALIGN                        ;Garante que o fim da seção está alinhada 
		END                          ;Fim do arquivo