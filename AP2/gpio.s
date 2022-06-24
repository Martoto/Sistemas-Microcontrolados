; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R             EQU    0x400FE608
SYSCTL_PRGPIO_R               EQU    0x400FEA08

GPIO_PORTA_AHB_DATA_BITS_R    EQU  0x40058000
GPIO_PORTA_AHB_DATA_R         EQU  0x400583FC
GPIO_PORTA_AHB_DIR_R          EQU  0x40058400
GPIO_PORTA_AHB_AFSEL_R        EQU  0x40058420
GPIO_PORTA_AHB_PUR_R          EQU  0x40058510
GPIO_PORTA_AHB_DEN_R          EQU  0x4005851C
GPIO_PORTA_AHB_LOCK_R         EQU  0x40058520
GPIO_PORTA_AHB_CR_R           EQU  0x40058524
GPIO_PORTA_AHB_AMSEL_R        EQU  0x40058528
GPIO_PORTA_AHB_PCTL_R         EQU  0x4005852C

GPIO_PORTB_AHB_DATA_BITS_R    EQU  0x40059000
GPIO_PORTB_AHB_DATA_R         EQU  0x400593FC
GPIO_PORTB_AHB_DIR_R          EQU  0x40059400
GPIO_PORTB_AHB_AFSEL_R        EQU  0x40059420
GPIO_PORTB_AHB_PUR_R          EQU  0x40059510
GPIO_PORTB_AHB_DEN_R          EQU  0x4005951C
GPIO_PORTB_AHB_LOCK_R         EQU  0x40059520
GPIO_PORTB_AHB_CR_R           EQU  0x40059524
GPIO_PORTB_AHB_AMSEL_R        EQU  0x40059528
GPIO_PORTB_AHB_PCTL_R         EQU  0x4005952C

; GPIO_PORTC_AHB_DATA_BITS_R    EQU  0x4005A000
; GPIO_PORTC_AHB_DATA_R         EQU  0x4005A3FC
; GPIO_PORTC_AHB_DIR_R          EQU  0x4005A400
; GPIO_PORTC_AHB_AFSEL_R        EQU  0x4005A420
; GPIO_PORTC_AHB_PUR_R          EQU  0x4005A510
; GPIO_PORTC_AHB_DEN_R          EQU  0x4005A51C
; GPIO_PORTC_AHB_LOCK_R         EQU  0x4005A520
; GPIO_PORTC_AHB_CR_R           EQU  0x4005A524
; GPIO_PORTC_AHB_AMSEL_R        EQU  0x4005A528
; GPIO_PORTC_AHB_PCTL_R         EQU  0x4005A52C

; GPIO_PORTD_AHB_DATA_BITS_R    EQU  0x4005B000
; GPIO_PORTD_AHB_DATA_R         EQU  0x4005B3FC
; GPIO_PORTD_AHB_DIR_R          EQU  0x4005B400
; GPIO_PORTD_AHB_AFSEL_R        EQU  0x4005B420
; GPIO_PORTD_AHB_PUR_R          EQU  0x4005B510
; GPIO_PORTD_AHB_DEN_R          EQU  0x4005B51C
; GPIO_PORTD_AHB_LOCK_R         EQU  0x4005B520
; GPIO_PORTD_AHB_CR_R           EQU  0x4005B524
; GPIO_PORTD_AHB_AMSEL_R        EQU  0x4005B528
; GPIO_PORTD_AHB_PCTL_R         EQU  0x4005B52C

; GPIO_PORTE_AHB_DATA_BITS_R    EQU  0x4005C000
; GPIO_PORTE_AHB_DATA_R         EQU  0x4005C3FC
; GPIO_PORTE_AHB_DIR_R          EQU  0x4005C400
; GPIO_PORTE_AHB_AFSEL_R        EQU  0x4005C420
; GPIO_PORTE_AHB_PUR_R          EQU  0x4005C510
; GPIO_PORTE_AHB_DEN_R          EQU  0x4005C51C
; GPIO_PORTE_AHB_LOCK_R         EQU  0x4005C520
; GPIO_PORTE_AHB_CR_R           EQU  0x4005C524
; GPIO_PORTE_AHB_AMSEL_R        EQU  0x4005C528
; GPIO_PORTE_AHB_PCTL_R         EQU  0x4005C52C

; GPIO_PORTF_AHB_DATA_BITS_R    EQU  0x4005D000
; GPIO_PORTF_AHB_DATA_R         EQU  0x4005D3FC
; GPIO_PORTF_AHB_DIR_R          EQU  0x4005D400
; GPIO_PORTF_AHB_AFSEL_R        EQU  0x4005D420
; GPIO_PORTF_AHB_PUR_R          EQU  0x4005D510
; GPIO_PORTF_AHB_DEN_R          EQU  0x4005D51C
; GPIO_PORTF_AHB_LOCK_R         EQU  0x4005D520
; GPIO_PORTF_AHB_CR_R           EQU  0x4005D524
; GPIO_PORTF_AHB_AMSEL_R        EQU  0x4005D528
; GPIO_PORTF_AHB_PCTL_R         EQU  0x4005D52C

; GPIO_PORTG_AHB_DATA_BITS_R    EQU  0x4005E000
; GPIO_PORTG_AHB_DATA_R         EQU  0x4005E3FC
; GPIO_PORTG_AHB_DIR_R          EQU  0x4005E400
; GPIO_PORTG_AHB_AFSEL_R        EQU  0x4005E420
; GPIO_PORTG_AHB_PUR_R          EQU  0x4005E510
; GPIO_PORTG_AHB_DEN_R          EQU  0x4005E51C
; GPIO_PORTG_AHB_LOCK_R         EQU  0x4005E520
; GPIO_PORTG_AHB_CR_R           EQU  0x4005E524
; GPIO_PORTG_AHB_AMSEL_R        EQU  0x4005E528
; GPIO_PORTG_AHB_PCTL_R         EQU  0x4005E52C

; GPIO_PORTH_AHB_DATA_BITS_R    EQU  0x4005F000
; GPIO_PORTH_AHB_DATA_R         EQU  0x4005F3FC
; GPIO_PORTH_AHB_DIR_R          EQU  0x4005F400
; GPIO_PORTH_AHB_AFSEL_R        EQU  0x4005F420
; GPIO_PORTH_AHB_PUR_R          EQU  0x4005F510
; GPIO_PORTH_AHB_DEN_R          EQU  0x4005F51C
; GPIO_PORTH_AHB_LOCK_R         EQU  0x4005F520
; GPIO_PORTH_AHB_CR_R           EQU  0x4005F524
; GPIO_PORTH_AHB_AMSEL_R        EQU  0x4005F528
; GPIO_PORTH_AHB_PCTL_R         EQU  0x4005F52C

GPIO_PORTJ_AHB_DATA_BITS_R EQU  0x40060000
GPIO_PORTJ_AHB_DATA_R      EQU  0x400603FC
GPIO_PORTJ_AHB_DIR_R       EQU  0x40060400
GPIO_PORTJ_AHB_IS_R        EQU  0x40060404
GPIO_PORTJ_AHB_IBE_R       EQU  0x40060408
GPIO_PORTJ_AHB_IEV_R       EQU  0x4006040C
GPIO_PORTJ_AHB_IM_R        EQU  0x40060410
GPIO_PORTJ_AHB_RIS_R       EQU  0x40060414
GPIO_PORTJ_AHB_MIS_R       EQU  0x40060418
GPIO_PORTJ_AHB_ICR_R       EQU  0x4006041C
GPIO_PORTJ_AHB_AFSEL_R     EQU  0x40060420
GPIO_PORTJ_AHB_DR2R_R      EQU  0x40060500
GPIO_PORTJ_AHB_DR4R_R      EQU  0x40060504
GPIO_PORTJ_AHB_DR8R_R      EQU  0x40060508
GPIO_PORTJ_AHB_ODR_R       EQU  0x4006050C
GPIO_PORTJ_AHB_PUR_R       EQU  0x40060510
GPIO_PORTJ_AHB_PDR_R       EQU  0x40060514
GPIO_PORTJ_AHB_SLR_R       EQU  0x40060518
GPIO_PORTJ_AHB_DEN_R       EQU  0x4006051C
GPIO_PORTJ_AHB_LOCK_R      EQU  0x40060520
GPIO_PORTJ_AHB_CR_R        EQU  0x40060524
GPIO_PORTJ_AHB_AMSEL_R     EQU  0x40060528
GPIO_PORTJ_AHB_PCTL_R      EQU  0x4006052C
GPIO_PORTJ_AHB_ADCCTL_R    EQU  0x40060530
GPIO_PORTJ_AHB_DMACTL_R    EQU  0x40060534
GPIO_PORTJ_AHB_SI_R        EQU  0x40060538
GPIO_PORTJ_AHB_DR12R_R     EQU  0x4006053C
GPIO_PORTJ_AHB_WAKEPEN_R   EQU  0x40060540
GPIO_PORTJ_AHB_WAKELVL_R   EQU  0x40060544
GPIO_PORTJ_AHB_WAKESTAT_R  EQU  0x40060548
GPIO_PORTJ_AHB_PP_R        EQU  0x40060FC0
GPIO_PORTJ_AHB_PC_R        EQU  0x40060FC4


GPIO_PORTK_DATA_BITS_R        EQU  0x40061000
GPIO_PORTK_DATA_R             EQU  0x400613FC
GPIO_PORTK_DIR_R              EQU  0x40061400
GPIO_PORTK_AFSEL_R            EQU  0x40061420
GPIO_PORTK_PUR_R              EQU  0x40061510
GPIO_PORTK_DEN_R              EQU  0x4006151C
GPIO_PORTK_LOCK_R             EQU  0x40061520
GPIO_PORTK_CR_R               EQU  0x40061524
GPIO_PORTK_AMSEL_R            EQU  0x40061528
GPIO_PORTK_PCTL_R             EQU  0x4006152C

GPIO_PORTL_DATA_BITS_R    EQU  0x40062000
GPIO_PORTL_DATA_R         EQU  0x400623FC
GPIO_PORTL_DIR_R          EQU  0x40062400
GPIO_PORTL_IS_R           EQU  0x40062404
GPIO_PORTL_IBE_R          EQU  0x40062408
GPIO_PORTL_IEV_R          EQU  0x4006240C
GPIO_PORTL_IM_R           EQU  0x40062410
GPIO_PORTL_RIS_R          EQU  0x40062414
GPIO_PORTL_MIS_R          EQU  0x40062418
GPIO_PORTL_ICR_R          EQU  0x4006241C
GPIO_PORTL_AFSEL_R        EQU  0x40062420
GPIO_PORTL_DR2R_R         EQU  0x40062500
GPIO_PORTL_DR4R_R         EQU  0x40062504
GPIO_PORTL_DR8R_R         EQU  0x40062508
GPIO_PORTL_ODR_R          EQU  0x4006250C
GPIO_PORTL_PUR_R          EQU  0x40062510
GPIO_PORTL_PDR_R          EQU  0x40062514
GPIO_PORTL_SLR_R          EQU  0x40062518
GPIO_PORTL_DEN_R          EQU  0x4006251C
GPIO_PORTL_LOCK_R         EQU  0x40062520
GPIO_PORTL_CR_R           EQU  0x40062524
GPIO_PORTL_AMSEL_R        EQU  0x40062528
GPIO_PORTL_PCTL_R         EQU  0x4006252C
GPIO_PORTL_ADCCTL_R       EQU  0x40062530
GPIO_PORTL_DMACTL_R       EQU  0x40062534
GPIO_PORTL_SI_R           EQU  0x40062538
GPIO_PORTL_DR12R_R        EQU  0x4006253C
GPIO_PORTL_WAKEPEN_R      EQU  0x40062540
GPIO_PORTL_WAKELVL_R      EQU  0x40062544
GPIO_PORTL_WAKESTAT_R     EQU  0x40062548
GPIO_PORTL_PP_R           EQU  0x40062FC0
GPIO_PORTL_PC_R           EQU  0x40062FC4

GPIO_PORTM_DATA_BITS_R        EQU  0x40063000
GPIO_PORTM_DATA_R             EQU  0x400633FC
GPIO_PORTM_DIR_R              EQU  0x40063400
GPIO_PORTM_AFSEL_R            EQU  0x40063420
GPIO_PORTM_PUR_R              EQU  0x40063510
GPIO_PORTM_DEN_R              EQU  0x4006351C
GPIO_PORTM_LOCK_R             EQU  0x40063520
GPIO_PORTM_CR_R               EQU  0x40063524
GPIO_PORTM_AMSEL_R            EQU  0x40063528
GPIO_PORTM_PCTL_R             EQU  0x4006352C

GPIO_PORTN_DATA_BITS_R        EQU  0x40064000
GPIO_PORTN_DATA_R             EQU  0x400643FC
GPIO_PORTN_DIR_R              EQU  0x40064400
GPIO_PORTN_AFSEL_R            EQU  0x40064420
GPIO_PORTN_PUR_R              EQU  0x40064510
GPIO_PORTN_DEN_R              EQU  0x4006451C
GPIO_PORTN_LOCK_R             EQU  0x40064520
GPIO_PORTN_CR_R               EQU  0x40064524
GPIO_PORTN_AMSEL_R            EQU  0x40064528
GPIO_PORTN_PCTL_R             EQU  0x4006452C

GPIO_PORTP_DATA_BITS_R        EQU  0x40065000
GPIO_PORTP_DATA_R             EQU  0x400653FC
GPIO_PORTP_DIR_R              EQU  0x40065400
GPIO_PORTP_AFSEL_R            EQU  0x40065420
GPIO_PORTP_PUR_R              EQU  0x40065510
GPIO_PORTP_DEN_R              EQU  0x4006551C
GPIO_PORTP_LOCK_R             EQU  0x40065520
GPIO_PORTP_CR_R               EQU  0x40065524
GPIO_PORTP_AMSEL_R            EQU  0x40065528
GPIO_PORTP_PCTL_R             EQU  0x4006552C

GPIO_PORTQ_DATA_BITS_R        EQU  0x40066000
GPIO_PORTQ_DATA_R             EQU  0x400663FC
GPIO_PORTQ_DIR_R              EQU  0x40066400
GPIO_PORTQ_AFSEL_R            EQU  0x40066420
GPIO_PORTQ_PUR_R              EQU  0x40066510
GPIO_PORTQ_DEN_R              EQU  0x4006651C
GPIO_PORTQ_LOCK_R             EQU  0x40066520
GPIO_PORTQ_CR_R               EQU  0x40066524
GPIO_PORTQ_AMSEL_R            EQU  0x40066528
GPIO_PORTQ_PCTL_R             EQU  0x4006652C

GPIO_PORTA                    EQU  2_000000000000001
GPIO_PORTB                    EQU  2_000000000000010
GPIO_PORTC                    EQU  2_000000000000100
GPIO_PORTD                    EQU  2_000000000001000
GPIO_PORTE                    EQU  2_000000000010000
GPIO_PORTF                    EQU  2_000000000100000
GPIO_PORTG                    EQU  2_000000001000000
GPIO_PORTH                    EQU  2_000000010000000
GPIO_PORTJ                    EQU  2_000000100000000
GPIO_PORTK                    EQU  2_000001000000000
GPIO_PORTL                    EQU  2_000010000000000
GPIO_PORTM                    EQU  2_000100000000000
GPIO_PORTN                    EQU  2_001000000000000
GPIO_PORTP                    EQU  2_010000000000000
GPIO_PORTQ                    EQU  2_100000000000000

NVIC_EN0_R                EQU  0xE000E100
NVIC_EN1_R                EQU  0xE000E104
NVIC_EN2_R                EQU  0xE000E108
NVIC_EN3_R                EQU  0xE000E10C
NVIC_DIS0_R               EQU  0xE000E180
NVIC_DIS1_R               EQU  0xE000E184
NVIC_DIS2_R               EQU  0xE000E188
NVIC_DIS3_R               EQU  0xE000E18C
NVIC_PEND0_R              EQU  0xE000E200
NVIC_PEND1_R              EQU  0xE000E204
NVIC_PEND2_R              EQU  0xE000E208
NVIC_PEND3_R              EQU  0xE000E20C
NVIC_UNPEND0_R            EQU  0xE000E280
NVIC_UNPEND1_R            EQU  0xE000E284
NVIC_UNPEND2_R            EQU  0xE000E288
NVIC_UNPEND3_R            EQU  0xE000E28C
NVIC_ACTIVE0_R            EQU  0xE000E300
NVIC_ACTIVE1_R            EQU  0xE000E304
NVIC_ACTIVE2_R            EQU  0xE000E308
NVIC_ACTIVE3_R            EQU  0xE000E30C
NVIC_PRI0_R               EQU  0xE000E400
NVIC_PRI1_R               EQU  0xE000E404
NVIC_PRI2_R               EQU  0xE000E408
NVIC_PRI3_R               EQU  0xE000E40C
NVIC_PRI4_R               EQU  0xE000E410
NVIC_PRI6_R               EQU  0xE000E418
NVIC_PRI5_R               EQU  0xE000E414
NVIC_PRI7_R               EQU  0xE000E41C
NVIC_PRI8_R               EQU  0xE000E420
NVIC_PRI9_R               EQU  0xE000E424
NVIC_PRI10_R              EQU  0xE000E428
NVIC_PRI11_R              EQU  0xE000E42C
NVIC_PRI12_R              EQU  0xE000E430
NVIC_PRI13_R              EQU  0xE000E434
NVIC_PRI14_R              EQU  0xE000E438
NVIC_PRI15_R              EQU  0xE000E43C
NVIC_PRI16_R              EQU  0xE000E440
NVIC_PRI17_R              EQU  0xE000E444
NVIC_PRI18_R              EQU  0xE000E448
NVIC_PRI19_R              EQU  0xE000E44C
NVIC_PRI20_R              EQU  0xE000E450
NVIC_PRI21_R              EQU  0xE000E454
NVIC_PRI22_R              EQU  0xE000E458
NVIC_PRI23_R              EQU  0xE000E45C
NVIC_PRI24_R              EQU  0xE000E460
NVIC_PRI25_R              EQU  0xE000E464
NVIC_PRI26_R              EQU  0xE000E468
NVIC_PRI27_R              EQU  0xE000E46C
NVIC_PRI28_R              EQU  0xE000E470
; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

        ; Se alguma função do arquivo for chamada em outro arquivo
    EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
    EXPORT PortQ_Output         ; Permite chamar PortQ_Output de outro arquivo
    EXPORT PortA_Output         ; Permite chamar PortA_Output de outro arquivo
    EXPORT PortB_Output         ; Permite chamar PortB_Output de outro arquivo
    EXPORT PortP_Output         ; Permite chamar PortP_Output de outro arquivo
    EXPORT PortK_Output         ; Permite chamar PortM_Output de outro arquivo
    EXPORT PortM_Output         ; Permite chamar PortK_Output de outro arquivo
    EXPORT PortN_Output         ; Permite chamar PortN_Output de outro arquivo
    EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
    EXPORT PortL_Input          ; Permite chamar PortL_Input de outro arquivo
    EXPORT PortM_Input          ; Permite chamar PortM_Input de outro arquivo
    EXPORT PortJ_Init           ; Permite chamar PortJ_Init de outro arquivo
    EXPORT GPIOPortJ_Handler
    IMPORT Zerar_Tabuadas       ; Zera todas as tabuadas
    EXPORT GPIO_PORTM_DIR_R
    EXPORT PortM_ConfigDir

GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; após isso verificar no PRGPIO se a porta está pronta para uso.
; enable clock to GPIOF at clock gating register
    LDR     R0, =SYSCTL_RCGCGPIO_R          ;Carrega o endereço do registrador RCGCGPIO
    MOV     R1, #GPIO_PORTQ              ;Seta o bit da porta Q
    ORR     R1, #GPIO_PORTA                 ;Seta o bit da porta A, fazendo com OR
    ORR     R1, #GPIO_PORTB                 ;Seta o bit da porta B, fazendo com OR
    ORR     R1, #GPIO_PORTP                 ;Seta o bit da porta P, fazendo com OR
    ORR     R1, #GPIO_PORTN                 ;Seta o bit da porta N, fazendo com OR
    ORR     R1, #GPIO_PORTK                 ;Seta o bit da porta K, fazendo com OR
    ORR     R1, #GPIO_PORTM                 ;Seta o bit da porta M, fazendo com OR
    ORR     R1, #GPIO_PORTL                 ;Seta o bit da porta L, fazendo com OR
    ORR     R1, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
    STR     R1, [R0]                        ;Move para a memória os bits das portas no endereço do RCGCGPIO

    LDR     R0, =SYSCTL_PRGPIO_R            ;Carrega o endereço do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]                ;Lê da memória o conteúdo do endereço do registrador
    MOV     R2, #GPIO_PORTQ                 ;Seta os bits correspondentes às portas para fazer a comparação
    ORR     R2, #GPIO_PORTA                 ;Seta o bit da porta A, fazendo com OR
    ORR     R2, #GPIO_PORTB                 ;Seta o bit da porta B, fazendo com OR
    ORR     R2, #GPIO_PORTP                 ;Seta o bit da porta P, fazendo com OR
    ORR     R2, #GPIO_PORTN                 ;Seta o bit da porta N, fazendo com OR
    ORR     R2, #GPIO_PORTK                 ;Seta o bit da porta K, fazendo com OR
    ORR     R2, #GPIO_PORTM                 ;Seta o bit da porta M, fazendo com OR
    ORR     R2, #GPIO_PORTL                 ;Seta o bit da porta L, fazendo com OR
    ORR     R2, #GPIO_PORTJ                 ;Seta o bit da porta J, fazendo com OR
    TST     R1, R2                          ;Testa o R1 com R2 fazendo R1 & R2
    BEQ     EsperaGPIO                      ;Se o flag Z=1, volta para o laço. Senão continua executando

; 2. Limpar o AMSEL para desabilitar a analógica
    MOV     R1, #0x00                        ;Colocar 0 no registrador para desabilitar a função analógica
    LDR     R0, =GPIO_PORTQ_AMSEL_R         ;Carrega o R0 com o endereço do AMSEL para a porta Q
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta Q da memória
    LDR     R0, =GPIO_PORTA_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta A
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta A da memória
    LDR     R0, =GPIO_PORTB_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta B
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta B da memória
    LDR     R0, =GPIO_PORTP_AMSEL_R         ;Carrega o R0 com o endereço do AMSEL para a porta P
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta P da memória
    LDR     R0, =GPIO_PORTN_AMSEL_R         ;Carrega o R0 com o endereço do AMSEL para a porta N
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta N da memória
    LDR     R0, =GPIO_PORTK_AMSEL_R         ;Carrega o R0 com o endereço do AMSEL para a porta K
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta K da memória
    LDR     R0, =GPIO_PORTM_AMSEL_R         ;Carrega o R0 com o endereço do AMSEL para a porta M
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta M da memória
    LDR     R0, =GPIO_PORTL_AMSEL_R         ;Carrega o R0 com o endereço do AMSEL para a porta L
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta L da memória
    LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     ;Carrega o R0 com o endereço do AMSEL para a porta J
    STR     R1, [R0]                        ;Guarda no registrador AMSEL da porta J da memória

; 3. Limpar PCTL para selecionar o GPIO
    MOV     R1, #0x00                       ;Colocar 0 no registrador para selecionar o modo GPIO
    LDR     R0, =GPIO_PORTQ_PCTL_R          ;Carrega o R0 com o endereço do PCTL para a porta Q
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta Q da memória
    LDR     R0, =GPIO_PORTA_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta A
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta A da memória
    LDR     R0, =GPIO_PORTB_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta B
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta B da memória
    LDR     R0, =GPIO_PORTP_PCTL_R          ;Carrega o R0 com o endereço do PCTL para a porta P
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta P da memória
    LDR     R0, =GPIO_PORTN_PCTL_R          ;Carrega o R0 com o endereço do PCTL para a porta N
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta N da memória
    LDR     R0, =GPIO_PORTK_PCTL_R          ;Carrega o R0 com o endereço do PCTL para a porta K
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta K da memória
    LDR     R0, =GPIO_PORTM_PCTL_R          ;Carrega o R0 com o endereço do PCTL para a porta M
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta M da memória
    LDR     R0, =GPIO_PORTL_PCTL_R          ;Carrega o R0 com o endereço do PCTL para a porta L
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta L da memória
    LDR     R0, =GPIO_PORTJ_AHB_PCTL_R      ;Carrega o R0 com o endereço do PCTL para a porta J
    STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da memória

; 4. DIR para 0 se for entrada, 1 se for saída
    LDR     R0, =GPIO_PORTQ_DIR_R           ;Carrega o R0 com o endereço do DIR para a porta Q
    MOV     R1, #2_1111                     ; PQ0, PQ1, PQ2, PQ3
    STR     R1, [R0]                        ;Guarda no registrador

    LDR     R0, =GPIO_PORTA_AHB_DIR_R       ;Carrega o R0 com o endereço do DIR para a porta A
    MOV     R1, #2_11110000                 ; PA4, PA5, PA6, PA7
    STR     R1, [R0]                        ;Guarda no registrador

    LDR     R0, =GPIO_PORTB_AHB_DIR_R       ;Carrega o R0 com o endereço do DIR para a porta B
    MOV     R1, #2_110000                   ; PB4, PB5
    STR     R1, [R0]                        ;Guarda no registrador

    LDR     R0, =GPIO_PORTP_DIR_R           ;Carrega o R0 com o endereço do DIR para a porta P
    MOV     R1, #2_100000                   ; PP5
    STR     R1, [R0]                        ;Guarda no registrador

    LDR     R0, =GPIO_PORTN_DIR_R           ;Carrega o R0 com o endereço do DIR para a porta N
    MOV     R1, #2_000010                   ; PN1
    STR     R1, [R0]                        ;Guarda no registrador

    LDR     R0, =GPIO_PORTK_DIR_R           ;Carrega o R0 com o endereço do DIR para a porta K
    MOV     R1, #0xFF                       ; PK0-7
    STR     R1, [R0]                        ;Guarda no registrador

    LDR     R0, =GPIO_PORTM_DIR_R           ;Carrega o R0 com o endereço do DIR para a porta M
    MOV     R1, #2_11110111                   ; PM0, PM1, PM2, PM4, PM5, PM6, PM7
    STR     R1, [R0]                        ;Guarda no registrador

    ; entradas
    LDR     R0, =GPIO_PORTJ_AHB_DIR_R       ;Carrega o R0 com o endereço do DIR para a porta J
    LDR     R1, [R0]                        ;Carrega os valores anteriores
    BIC     R1, R1, #2_01                   ;Limpar PJ0 e PJ2 no registrador DIR para funcionar com entrada
    STR     R1, [R0]                        ;Guarda no registrador DIR da porta J da memória

    LDR     R0, =GPIO_PORTL_DIR_R           ;Carrega o R0 com o endereço do DIR para a porta L
    LDR     R1, [R0]                        ;Carrega os valores anteriores
    BIC     R1, R1, #2_1111                 ;Limpar PL0-3 no registrador DIR para funcionar com entrada
    STR     R1, [R0]                        ;Guarda no registrador DIR da porta L da memória

; 5. Limpar os bits AFSEL para 0 para selecionar GPIO
;    Sem função alternativa
    MOV     R1, #0x00                       ;Colocar o valor 0 para não setar função alternativa

    LDR     R0, =GPIO_PORTQ_AFSEL_R         ;Carrega o endereço do AFSEL da porta Q
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTA_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta A
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTB_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta B
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTP_AFSEL_R         ;Carrega o endereço do AFSEL da porta P
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTN_AFSEL_R         ;Carrega o endereço do AFSEL da porta N
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTK_AFSEL_R         ;Carrega o endereço do AFSEL da porta K
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTM_AFSEL_R         ;Carrega o endereço do AFSEL da porta M
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTL_AFSEL_R         ;Carrega o endereço do AFSEL da porta L
    STR     R1, [R0]                        ;Escreve na porta

    LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endereço do AFSEL da porta J
    STR     R1, [R0]                        ;Escreve na porta

; 6. Setar os bits de DEN para habilitar I/O digital
    LDR     R0, =GPIO_PORTQ_DEN_R           ;Carrega o endereço do DEN da porta Q
    MOV     R1, #2_1111                     ; PQ0, PQ1, PQ2, PQ3
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTA_AHB_DEN_R       ;Carrega o endereço do DEN da porta A
    MOV     R1, #2_11110000                 ; PA4, PA5, PA6, PA7
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTB_AHB_DEN_R       ;Carrega o endereço do DEN da porta B
    MOV     R1, #2_110000                   ; PB4, PB5
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTJ_AHB_DEN_R       ;Carrega o endereço do DEN da porta J
    MOV     R1, #2_01                       ; PJ0, PJ1
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTP_DEN_R           ;Carrega o endereço do DEN da porta P
    MOV     R1, #2_100000                   ; PP5
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTN_DEN_R           ;Carrega o endereço do DEN da porta N
    MOV     R1, #2_000010                   ; PN1
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTK_DEN_R           ;Carrega o endereço do DEN da porta K
    MOV     R1, #0xFF                       ; PN0-7
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTM_DEN_R           ;Carrega o endereço do DEN da porta M
    MOV     R1, #2_11110111                 ; PM0, PM1, PM2, PM4, PM5, PM6, PM7
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

    LDR     R0, =GPIO_PORTL_DEN_R           ;Carrega o endereço do DEN da porta L
    MOV     R1, #2_001111                   ; PL0, PL1, PL2, PL3
    STR     R1, [R0]                        ;Escreve no registrador da memória funcionalidade digital

; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
    LDR     R0, =GPIO_PORTQ_PUR_R           ;Carrega o endereço do PUR para a porta J
    MOV     R1, #2_1111                     ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTA_AHB_PUR_R       ;Carrega o endereço do PUR para a porta A
    MOV     R1, #2_11110000                 ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTB_AHB_PUR_R       ;Carrega o endereço do PUR para a porta B
    MOV     R1, #2_110000                   ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTJ_AHB_PUR_R       ;Carrega o endereço do PUR para a porta J
    MOV     R1, #2_01                       ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTP_PUR_R           ;Carrega o endereço do PUR para a porta P
    MOV     R1, #2_100000                   ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTN_PUR_R           ;Carrega o endereço do PUR para a porta N
    MOV     R1, #2_000010                   ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTK_PUR_R           ;Carrega o endereço do PUR para a porta K
    MOV     R1, #0xFF                       ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTM_PUR_R           ;Carrega o endereço do PUR para a porta M
    MOV     R1, #2_11110111                 ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up

    LDR     R0, =GPIO_PORTL_PUR_R           ;Carrega o endereço do PUR para a porta L
    MOV     R1, #2_001111                   ;Habilitar funcionalidade digital de resistor de pull-up
    STR     R1, [R0]                        ;Escreve no registrador da memória do resistor de pull-up
    BX      LR


PortQ_Output
    LDR    R1, =GPIO_PORTQ_DATA_R          ;Carrega o valor do offset do data register
    ;Read-Modify-Write para escrita
    LDR R2, [R1]
    BIC R2, #2_1111                   ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11110000
    ORR R0, R0, R2                    ;Fazer o OR do lido pela porta com o parâmetro de entrada
    STR R0, [R1]                      ;Escreve na porta Q o barramento de dados do pino PQ0, PQ1, PQ2, PQ3
    BX LR                              ;Retorno


PortA_Output
    LDR    R1, =GPIO_PORTA_AHB_DATA_R          ;Carrega o valor do offset do data register
    ;Read-Modify-Write para escrita
    LDR R2, [R1]
    BIC R2, #2_11110000               ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11110000
    ORR R0, R0, R2                    ;Fazer o OR do lido pela porta com o parâmetro de entrada
    STR R0, [R1]                      ;Escreve na porta A o barramento de dados do pino PA7, PA6, PA5, PA4
    BX LR                              ;Retorno


PortB_Output
    LDR    R1, =GPIO_PORTB_AHB_DATA_R      ;Carrega o valor do offset do data register
    ;Read-Modify-Write para escrita
    LDR R2, [R1]
    BIC R2, #2_00110000               ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 1100000
    ORR R0, R0, R2                    ;Fazer o OR do lido pela porta com o parâmetro de entrada
    STR R0, [R1]                      ;Escreve na porta B o barramento de dados do pino PB4, PB5
    BX LR                              ;Retorno


PortP_Output
    LDR    R1, =GPIO_PORTP_DATA_R          ;Carrega o valor do offset do data register
    ;Read-Modify-Write para escrita
    LDR R2, [R1]
    BIC R2, #2_00100000               ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 100000
    ORR R0, R0, R2                    ;Fazer o OR do lido pela porta com o parâmetro de entrada
    STR R0, [R1]                      ;Escreve na porta P o barramento de dados do pino PP5
    BX LR                              ;Retorno


PortN_Output
    LDR    R1, =GPIO_PORTN_DATA_R          ;Carrega o valor do offset do data register
    ;Read-Modify-Write para escrita
    LDR R2, [R1]
    BIC R2, #2_00000010               ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 000010
    ORR R0, R0, R2                    ;Fazer o OR do lido pela porta com o parâmetro de entrada
    STR R0, [R1]                      ;Escreve na porta N o barramento de dados do pino PP5
    BX LR                              ;Retorno


PortK_Output
    LDR R1, =GPIO_PORTK_DATA_R        ;Carrega o valor do offset do data register
    ;Read-Modify-Write para escrita
    LDR R2, [R1]
    BIC R2, #0xFF                     ;Primeiro limpamos os 8 bits do lido da porta R2 = R2 & ~0xFF
    ORR R0, R0, R2                    ;Fazer o OR do lido pela porta com o parâmetro de entrada
    STR R0, [R1]                      ;Escreve na porta K
    BX LR                             ;Retorno


PortM_Output
    LDR R1, =GPIO_PORTM_DATA_R        ;Carrega o valor do offset do data register
    ;Read-Modify-Write para escrita
    LDR R2, [R1]
    BIC R2, #2_11110111               ;Primeiro limpamos os 3 bits do lido da porta R2 = R2 & ~2_11110111
    ORR R0, R0, R2                    ;Fazer o OR do lido pela porta com o parâmetro de entrada
    STR R0, [R1]                      ;Escreve na porta M
    BX LR                             ;Retorno


PortJ_Input
    LDR R1, =GPIO_PORTJ_AHB_DATA_R          ;Carrega o valor do offset do data register
    LDR R0, [R1]                            ;Lê no barramento de dados dos pinos [J0]
    BX LR                                   ;Retorno

PortL_Input
    LDR R1, =GPIO_PORTL_DATA_R              ;Carrega o valor do offset do data register
    LDR R0, [R1]                            ;Lê no barramento de dados dos pinos
    BX LR                                   ;Retorno

PortM_Input
    LDR R1, =GPIO_PORTM_DATA_R              ;Carrega o valor do offset do data register
    LDR R0, [R1]                            ;Lê no barramento de dados dos pinos
    BX LR                                   ;Retorno

PortJ_Init
    LDR R1, =GPIO_PORTJ_AHB_IM_R
    LDR R0, [R1]
    BIC R0, #2_00000001               ;Primeiro limpamos os dois bits do lido da porta R0 = R0 & ~000011
    STR R0, [R1]                      ; Limpa os bits na porta GPIOIM da porta J

    LDR R1, =GPIO_PORTJ_AHB_IS_R
    LDR R0, [R1]
    BIC R0, #2_00000001               ;Primeiro limpamos os dois bits do lido da porta R0 = R0 & ~000011
    STR R0, [R1]                      ; Limpa os bits na porta GPIOIM da porta J

    LDR R1, =GPIO_PORTJ_AHB_IBE_R
    LDR R0, [R1]
    BIC R0, #2_00000001               ;Primeiro limpamos os dois bits do lido da porta R0 = R0 & ~000011
    STR R0, [R1]                      ; Limpa os bits na porta

    LDR R1, =GPIO_PORTJ_AHB_IEV_R
    LDR R0, [R1]
    BIC R0, #2_00000001               ;Primeiro limpamos os dois bits do lido da porta R0 = R0 & ~000011
    STR R0, [R1]                      ; Limpa os bits na porta

    LDR R1, =GPIO_PORTJ_AHB_ICR_R     ; Carrega do endereco do GPIOICR da porta J
    LDR R0, [R1]                      ; Lê os dados do GPIOICR da porta J
    ORR R0, #2_00000001               ; Setar BIT0 e BIT1 do GPIOICR da porta J
    STR R0, [R1]                      ; Escreve na porta

    LDR R1, =GPIO_PORTJ_AHB_IM_R
    LDR R0, [R1]
    ORR R0, #2_00000001               ; Ativar a interrupcao para PJ1 e PJ2
    STR R0, [R1]                      ; Setar BIT1 e BIT2 do GPIOIM da porta J

    LDR R1, =NVIC_EN1_R
    LDR R0, [R1]
    ORR R0, #0x080000
    STR R0, [R1]

    LDR R1, =NVIC_PRI12_R
    LDR R0, [R1]
    ORR R0, #0xA0000000               ;Primeiro limpamos os dois bits do lido da porta R0 = R0 & ~000011
    STR R0, [R1]                      ; Limpa os bits na porta GPIOIM da porta J
    BX LR                             ;Retorno

; -------------------------------------------------
; GPIOPortJ_handler
GPIOPortJ_Handler
    PUSH {LR}
    LDR    R1, =GPIO_PORTJ_AHB_RIS_R        ; Carrega o valor do offset do data register
    LDR R2, [R1]                            ; Lê no barramento de dados dos pinos [J0]

    LDR R1, =GPIO_PORTJ_AHB_ICR_R           ; Limpa os 
    MOV R0, #2_0001
    STR R0, [R1]

    CMP R2, #2_01                           ; Verifica se a SW1 foi acionada
    BL Zerar_Tabuadas                       ; Zera todas as tabuadas

    POP {PC}                                ; Retorna


PortM_ConfigDir
    PUSH {LR}
    LDR     R2, =GPIO_PORTM_DIR_R           ; Carrega o R2 com o endereço do DIR para a porta M
    LDR     R1, [R2]                        ; Carrega os valores anteriores em R1
    BIC     R1, #2_11110000                 ; Limpar PM4-7 no registrador DIR para funcionar com entrada
    ORR     R1, R0                          ; Setar os BITS 1 de R0 para funcionar como saida
    STR     R1, [R2]                        ; Guarda no registrador DIR da porta M da memória
    MOV R0, #0x00                           ; Coloca 0 nas portas configuradas com saída
    BL PortM_Output                         ; Escreve na porta M
    POP {LR}
    BX LR

; -------------------------------------------------
    ALIGN                           ; garante que o fim da seção está alinhada
    END                             ; fim do arquivo
