; ***************************************************************************************
; * Projeto ACom 2024 - PACMAN
; * Grupo: 2
; * Nomes: Goncalo Martins (110017), AFonso Freire (110756), Eduardo Proenca (110741)
; *
; ***************************************************************************************

; *********************************************************************************
; * Constantes Globais
; *********************************************************************************

DEFINE_LINHA    EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ      EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_FUNDO EQU 6042H      ; ender eço do comando para selecionar uma imagem de fundo
LE_VALOR_PIXEL EQU 6010H       ; endereço do comando para ler o valor de um pixel

; --- Colors --- ;
BLACK		EQU 0F000H
GREY_L0		EQU 08888H
GREY_L1		EQU 08999H
GREY_D0		EQU 0A666H
GREY_D1		EQU 0F333H
ORANGE		EQU 0FFC0H
YELLOW		EQU 0FFF0H
RED			EQU 0FF00H
GREEN		EQU 0F0F0H
PINK		EQU 0FF0FH
PURPLE		EQU 0F73AH
BLUE_L0		EQU 0F026H
BLUE_L1     EQU 0F049H

; --- Limites --- ;
MIN_COLUNA EQU 0		   ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA EQU 63          ; número da coluna mais à direita que o objeto pode ocupar
MIN_LINHA  EQU 0		   ; número da linha mais acima que o objeto pode ocupar
MAX_LINHA  EQU 10		   ; número da linha mais abaixo que o objeto pode ocupar
ATRASO EQU 400H	           ; atraso para limitar a velocidade de MOVIMENTO do boneco
CEM EQU 100H
TEMPO_DELAY EQU 2000H

; --- Teclas --- ;
TECLA_0 EQU 0011H ; MOVIMENTO na diagonal superior esquerda
TECLA_1 EQU 0012H; MOVIMENTO para cima
TECLA_2 EQU 0014H; MOVIMENTO na diagonal superior direita
TECLA_3 EQU 0018H; sem efeito
TECLA_4 EQU 0021H; MOVIMENTO para a esquerda
TECLA_5 EQU 0022H; sem efeito
TECLA_6 EQU 0024H; MOVIMENTO para a direita
TECLA_7 EQU 0028H; sem efeito
TECLA_8 EQU 0041H; MOVIMENTO na diagonal inferior esquerda
TECLA_9 EQU 0042H; MOVIMENTO para baixo
TECLA_A EQU 0044H; MOVIMENTO na diagonal inferior direita
TECLA_B EQU 0048H; sem efeito
TECLA_C EQU 0081H; Comecar o jogo
TECLA_D EQU 0082H; Pausar o Jogo/ Continuar o jogo
TECLA_E EQU 0084H; Terminar o Jogo
TECLA_F EQU 0088H; sem efeito

; --- Posicoes --- ;
POSICAO_INICIAL_PACMAN_X EQU 16 ; posicao inicial do pacman X
POSICAO_INICIAL_PACMAN_Y EQU 30 ; posicao inicial do pacman Y

; --- SOM --- ;
EMITIR_SOM EQU 605AH ; endereço do comando para emitir um som
PAUSA_SOM EQU 605EH ; endereço do comando para pausar um som

; --- Display --- ;
DISPLAY EQU 0A000H ; Endereco do display de 7 elementos

; --- Fantasmas --- ;
FANTASMA EQU 4; 4 fantasmas

; *********************************************************************************
; * DATA
; *********************************************************************************
PLACE 1000H
pilha:
	STACK 100H			; espaço reservado para a pilha
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser
    WORD 0						; inicializado. O 1.º end. de retorno será
						; armazenado em 11FEH (1200H-2)

DEF_FANTASMA:			    ; tabela que define o fantasma
	WORD GREEN
	BYTE 5					; largura do fantasma
	BYTE 5					; altura do fantasma
	BYTE 0, 1, 1, 1, 0
	BYTE 1, 1, 1, 1, 1
	BYTE 1, 1, 1, 1, 1
	BYTE 1, 0, 1, 0, 1
	BYTE 1, 0, 1, 0, 1

DEF_REBUCADO:
	WORD RED                ; tabela que define os rebuçados 
    BYTE 4
    BYTE 4
    BYTE 1, 0, 0, 1
    BYTE 0, 1, 1, 0
    BYTE 0, 1, 1, 0
    BYTE 1, 0, 0, 1

 DEF_PACMAN_DIREITA:			; tabela que define o pacman a andar
	WORD YELLOW
	BYTE 5					    ; largura do do pacman parado
	BYTE 5					    ; altura do pacman parado
	BYTE 0, 1, 1, 1, 0
	BYTE 1, 1, 1, 0, 0
	BYTE 1, 1, 0, 0, 0
	BYTE 1, 1, 1, 0, 0
	BYTE 0, 1, 1, 1, 0

DEF_PACMAN_BAIXO:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 1, 1, 1, 0
	BYTE 1, 1, 1, 1, 1
	BYTE 1, 1, 0, 1, 1
	BYTE 1, 0, 0, 0, 1
	BYTE 0, 0, 0, 0, 0

DEF_PACMAN_CIMA:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 0, 0, 0, 0
	BYTE 1, 0, 0, 0, 1
	BYTE 1, 1, 0, 1, 1
	BYTE 1, 1, 1, 1, 1
	BYTE 0, 1, 1, 1, 0

DEF_PACMAN_ESQUERDA:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 1, 1, 1, 0
	BYTE 0, 0, 1, 1, 1
	BYTE 0, 0, 0, 1, 1
	BYTE 0, 0, 1, 1, 1
	BYTE 0, 1, 1, 1, 0


DEF_PACMAN_DIAGONAL_D_C:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 1, 1, 0, 0
	BYTE 1, 1, 0, 0, 0
	BYTE 1, 1, 0, 0, 1
	BYTE 1, 1, 1, 1, 1
	BYTE 0, 1, 1, 1, 0

DEF_PACMAN_DIAGONAL_D_B:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 1, 1, 1, 0
	BYTE 1, 1, 1, 1, 1
	BYTE 1, 1, 0, 0, 1
	BYTE 1, 1, 0, 0, 0
	BYTE 0, 1, 1, 0, 0

DEF_PACMAN_DIAGONAL_E_C:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 0, 1, 1, 0
	BYTE 0, 0, 0, 1, 1
	BYTE 1, 0, 0, 1, 1
	BYTE 1, 1, 1, 1, 1
	BYTE 0, 1, 1, 1, 0

DEF_PACMAN_DIAGONAL_E_B:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 1, 1, 1, 0
	BYTE 1, 1, 1, 1, 1
	BYTE 1, 0, 0, 1, 1
	BYTE 0, 0, 0, 1, 1
	BYTE 0, 0, 1, 1, 0

DEF_PACMAN_PARADO:
	WORD YELLOW
	BYTE 5
	BYTE 5
	BYTE 0, 1, 1, 1, 0
	BYTE 1, 1, 1, 1, 1
	BYTE 1, 1, 1, 1, 1
	BYTE 1, 1, 1, 1, 1
	BYTE 0, 1, 1, 1, 0

 DEF_EXPLOSAO_INICIAL:
	WORD BLUE_L0
	BYTE 1H
	BYTE 1H
	BYTE 1

DEF_EXPLOSAO_INTERMEDIA:
	WORD BLUE_L0
	BYTE 3H
	BYTE 3H
	BYTE 1, 0, 1
	BYTE 0, 1, 0
	BYTE 1, 0, 1

DEF_EXPLOSAO_FINAL:         ; tabela que define a explosao final do pacman
	WORD BLUE_L0
	BYTE 5H                 ; altura de cruz
	BYTE 5H   	            ; largura da cruz
	BYTE 1, 0, 0, 0, 1
	BYTE 0, 1, 0, 1, 0
	BYTE 0, 0, 1, 0, 0
	BYTE 0, 1, 0, 1, 0
	BYTE 1, 0, 0, 0, 1

DEF_NINHO_PACMAN:           ; tabela que define o ninho/casa do pacman 
	WORD BLUE_L1
	BYTE 010H
	BYTE 09H
	BYTE 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1
	BYTE 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	BYTE 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1
	BYTE 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1

DEF_LINHA_FECHA_NINHO:     ; apos o pacman sair, o ninho vai ter estas linhas que fecham-o
	WORD BLUE_L1
	BYTE 8
	BYTE 1
	BYTE 1, 1, 1, 1, 1, 1, 1, 1

DEF_CORDS_LINHA_FECHA:
	BYTE 14
	BYTE 28

DEF_CORDS_PACMAN_SPAWN:
	BYTE 16
	BYTE 30

DEF_CORDS_FANTASMA1_SPAWN:
	BYTE 16
	BYTE 4

DEF_CORDS_FANTASMA2_SPAWN:
	BYTE 16
	BYTE 56

DEF_CORDS_NINHO_SPAWN:
	BYTE 14
	BYTE 24

DEF_CORDS_GRELHA_SPAWN:
	BYTE 0
	BYTE 0

DEF_CORDS_REBUCADO1_SPAWN:
    BYTE 2
    BYTE 2

DEF_CORDS_REBUCADO2_SPAWN:
    BYTE 26
    BYTE 2

DEF_CORDS_REBUCADO3_SPAWN:
    BYTE 2
    BYTE 58

DEF_CORDS_REBUCADO4_SPAWN:
    BYTE 26
    BYTE 58

DEF_PAR:
    BYTE 0

DEF_ESTADO_NINHO:
	WORD 0

DEF_NUMERO_REBUCADOS:
	BYTE 4

DEF_ESTADO_JOGO:
    WORD 0 ; 0 - Jogo em execucao, 1 - Jogo em pausa, 2 - Jogo terminado

INT_TABLE:
	WORD	int_0	; Relogio tempo
	WORD 	int_1   ; Relogio fantasma

; *********************************************************************************
; * Programa
; **********************************************************************************
 ; Registos reservados:
 ; R0 - Valor do teclado

PLACE   0   ; o código tem de começar em 0000H
    MOV  SP, SP_inicial
    MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1
    MOV R1, 0
    MOV  [SELECIONA_FUNDO], R1	; muda o cenário de fundo (o valor de R1 não é relevante)
    MOV R1, 1
    MOV [EMITIR_SOM], R1 ; emite a musica de quando o jogo esta em pausa  
    MENU_INICIAL:
    CALL CHAMA_TECLADO  ; inicia a funcao do teclado e espera que a tecla c seja primida para começar o jogo 
    MOV R5, TECLA_C
    CMP R0, R5
    JZ JOGAR
    JMP MENU_INICIAL

    JOGAR:
    MOV [PAUSA_SOM], R1
    MOV R2, 0
    MOV R1, 1
    MOV  [APAGA_ECRÃ], R1			; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
 	MOV  [SELECIONA_FUNDO], R1		; muda o cenário de fundo
    CALL DESENHA_GRELHA
 	MOV BTE, INT_TABLE

 	EI                              ; inicializacao das interrupcoes
 	EI0
 	EI1


	MOV	 R1, 0
	CALL DESENHA_NINHO
	CALL DESENHA_PACMAN_PARADO
	MOV R9, DEF_CORDS_REBUCADO1_SPAWN
	CALL DESENHA_REBUCADO                           ; vai desenhar no ecra os diferentes objetos do jogo nas suas respetivas coordenadas 
	MOV R9, DEF_CORDS_REBUCADO2_SPAWN
	CALL DESENHA_REBUCADO
	MOV R9, DEF_CORDS_REBUCADO3_SPAWN
	CALL DESENHA_REBUCADO
	MOV R9, DEF_CORDS_REBUCADO4_SPAWN
	CALL DESENHA_REBUCADO
	MOV R9, 0
    JMP ESPERA_TECLADO
    ESPERA_TECLADO_PARADO:
    ;CALL DESENHA_PACMAN_PARADO
    ESPERA_TECLADO:
    CALL CHAMA_TECLADO ; ciclo que verifica se ha alguma tecla premida 
    CMP R0, 0
    JZ ESPERA_TECLADO_PARADO                    
    MOVIMENTO:
    CMP R0, R2
    JZ MOVIMENTO_DELAY ; ativa o delay entre os movimentos do pacman 
    MOVIMENTO_CONTINUO:
    JMP VERIFICA_INPUT
INICIO:
	MOV R9, 0               ; inicializa o jogo 
	CALL COME_FRUTA
    MOV R2, R0
    CALL FUNCAO_DELAY                    
    CALL FUNCAO_DELAY
	CALL FECHAR_OU_NAO
	MOV R0, 0
    JMP ESPERA_TECLADO
    MOVIMENTO_DELAY:
    CALL FUNCAO_DELAY
    JMP MOVIMENTO_CONTINUO

; **********************************************************************
; CRIAR_BONECO - Desenha um fanstasma na linha e coluna indicadas
;			       com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - tabela do boneco
;               R9 - tabela de cordenadas (linha e coluna)
; **********************************************************************
CRIAR_BONECO:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	MOVB R2, [R9]			; obtém a linha onde será desenhado o boneco
	ADD R9, 1
	MOVB R3, [R9]			; obtém a coluna onde será desenhado o boneco
	MOV R8, [R1]			; obtem a cor do boneco
	ADD R1, 2
	MOVB R4, [R1]            ; obtém a largura do boneco
	MOVB R7, [R1]			; guarda a largura do boneco
	ADD R1, 1
	MOVB R5, [R1]			; obtém a altura do boneco
	ADD R1, 1

DESENHA_BONECO:
	MOVB R6, [R1]			; obtém a cor do proximo pixel
	CALL escreve_pixel
	ADD R1, 1				; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R3, 1          		; próxima coluna
    SUB R4, 1				; menos uma coluna para tratar
    JNZ DESENHA_BONECO    	; continua até percorrer toda a largura do objeto
	MOV R4, R7
	SUB R5, 1
	JNZ muda_linhas			; muda para a proxima linha
	POP R9
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET						; termina o desenho

muda_linhas:
	ADD R2, 1				; muda para a proxima linha
	SUB R3, R7				; volta a escrever no inicio da linha
	JMP DESENHA_BONECO

escreve_pixel:
	MOV [DEFINE_LINHA], R2		; seleciona a linha
	MOV [DEFINE_COLUNA], R3		; seleciona a coluna
	CMP R6, 1
	JZ pintar_pixel
	MOV [DEFINE_PIXEL], R6		; altera a cor do pixel na linha e coluna já selecionadas

return:
	RET

pintar_pixel:
	MOV [DEFINE_PIXEL], R8      ; altera a cor do pixel na linha e coluna já selecionadas
	JMP return

apagar_boneco:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	MOVB R2, [R9]			; obtém a linha onde será desenhado o boneco
	ADD R9, 1
	MOVB R3, [R9]			; obtém a coluna onde será desenhado o boneco
	MOV R8, 0			    ; obtem a cor do boneco
	ADD R1, 2
	MOVB R4, [R1]           ; obtém a largura do boneco
	MOVB R7, [R1]			; guarda a largura do boneco
	ADD R1, 1
	MOVB R5, [R1]			; obtém a altura do boneco
	ADD R1, 1
	JMP DESENHA_BONECO

; **********************************************************************
; VERIFICA_INPUT- Vai correr um ciclo pelas diferentes instrucoes ate ecnontrar a tecla premida
; Argumentos: Entrada- R0
;
; **********************************************************************

VERIFICA_INPUT:
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	ADD R10, 1
    MOV R2, TECLA_0                                    ; em geral, para todas as funções abaixo, irá ver que tecla está ser premida e irá executar a funcao respetiva 
    CMP R0, R2
    JZ TECLA_PRESS_0

    MOV R2, [DEF_NUMERO_REBUCADOS]
    CMP R2, 0
    JZ TECLA_PRESS_E

    MOV R2, TECLA_1
    CMP R0, R2
    JZ TECLA_PRESS_1

    MOV R2, TECLA_2
    CMP R0, R2
    JZ TECLA_PRESS_2

    MOV R2, TECLA_4
    CMP R0, R2
    JZ TECLA_PRESS_4

    MOV R2, TECLA_6
    CMP R0, R2
    JZ TECLA_PRESS_6

    MOV R2, TECLA_8
    CMP R0, R2
    JZ TECLA_PRESS_8

    MOV R2, TECLA_9
    CMP R0, R2
    JZ TECLA_PRESS_9

    MOV R2, TECLA_A
    CMP R0, R2
    JZ TECLA_PRESS_A

    MOV R2, TECLA_D
    CMP R0, R2
    JZ TECLA_PRESS_D

    MOV R2, TECLA_E
    CMP R0, R2
    JZ TECLA_PRESS_E


    JMP INICIO

    TECLA_PRESS_0:
    CALL MOVIMENTO_DIAGONAL_SUPERIOR_ESQUERDA
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_1:
    CALL MOVIMENTO_PARA_CIMA
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_2:
    CALL MOVIMENTO_DIAGONAL_SUPERIOR_DIREITA
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_4:
    CALL MOVIMENTO_ESQUERDA
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_6:
    CALL MOVIMENTO_DIREITA
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_8:
    CALL MOVIMENTO_DIAGONAL_INFERIOR_ESQUERDA
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_9:
    CALL MOVIMENTO_PARA_BAIXO
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_A:
    CALL MOVIMENTO_DIAGONAL_INFERIOR_DIREITA
	MOV R10, 0
	CALL EMITIR_1_SOM
    JMP INICIO

    TECLA_PRESS_D:
    CALL PAUSA_JOGO
    JMP INICIO

    TECLA_PRESS_E:
    CALL TERMINAR_JOGO

FIM:
	JMP FIM

EMITIR_1_SOM:
    PUSH R9
    MOV R9, 0
    MOV [EMITIR_SOM], R9            ;ira emitir o som escolhido 
    POP R9
    RET

; **********************************************************************
; TERMINAR_JOGO - Vai terminar o jogo
; **********************************************************************
TERMINAR_JOGO:
    PUSH R1
    MOV R1, 1
    MOV [APAGA_ECRÃ], R1
    MOV [DEF_ESTADO_JOGO], R1               ; move o bit de estado que termina jogo 
    MOV R1, 1                               ; muda o ecra para o ecra definal de jogo 
    MOV  [SELECIONA_FUNDO], R1              ; atualiza o display 
    POP R1 
    RET
; *********************************************************************************************************]
; PAUSA_JOGO - Vai pausar o jogo
; *********************************************************************************************************
PAUSA_JOGO:
    PUSH R0
    PUSH R1
    PUSH R2
    PUSH R3
    MOV R1, 1
    MOV [DEF_ESTADO_JOGO], R1 ; vai alterar o estado do jogo para pausado
    MOV R2, 2
    MOV  [SELECIONA_FUNDO], R2 ; seleciona o fundo de jogo pausado
    MOV [EMITIR_SOM], R1 ; Vai comecar a musica
    MOV [APAGA_ECRÃ], R1 ; e apagar todos os pixeis do ecra
    MOV R2, TECLA_D ;Vai guardar a tecla D em R2
    PAUSA_JOGO_LOOP:
    CALL CHAMA_TECLADO ; Vai chamar o teclado
    CMP R0, R2 ; Vai comparar a tecla premida com a tecla D
    JZ PAUSA_JOGO_LOOP ; E caso a tecla D esteja premida vai continuar no loop
    PAUSA_JOGO_LOOP_2:
    CALL CHAMA_TECLADO ; Vai chamar o teclado
    CMP R0, R2
    JNZ PAUSA_JOGO_LOOP_2 ; Caso a tecla premida nao seja o D vai continuar no loop
    SUB R1, 1
    CALL DESENHA_GRELHA
    MOV [DEF_ESTADO_JOGO], R1 ; Vai alterar o estado do jogo para em execucao
    MOV R1, 1
    CALL FUNCAO_DELAY
    MOV  [SELECIONA_FUNDO], R1 ; Vai selecionar o fundo de jogo em execucao
    CALL DESENHA_NINHO
    CALL DESENHA_REBUCADO
    CALL DESENHA_PACMAN_PARADO
    MOV R9, DEF_CORDS_REBUCADO1_SPAWN
    CALL DESENHA_REBUCADO
    MOV R9, DEF_CORDS_REBUCADO2_SPAWN         ; ira voltar a desenhar os objetos como estavam antes de do jogo ter sido pausado 
    CALL DESENHA_REBUCADO
    MOV R9, DEF_CORDS_REBUCADO3_SPAWN
    CALL DESENHA_REBUCADO
    MOV R9, DEF_CORDS_REBUCADO4_SPAWN
    CALL DESENHA_REBUCADO
    MOV R9, 0
    MOV [PAUSA_SOM], R1

    POP R3
    POP R2
    POP R1
    POP R0
    RET


; *********************************************************************************************************
; Interrupcoes
; *********************************************************************************************************
int_0:
    PUSH R1
    MOV R1, [DEF_ESTADO_JOGO]        ; carrega o estado atual de jogo 
    CMP R1, 1
    JZ FIM_INT_0
    CALL CALL_CONTADOR ; Vai chamar o contador enquanto n\ao apanhar 1 fruta
    FIM_INT_0:
    POP R1
    RFE

int_1:                ; interrupcao que faz o fantasma se mexer 
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9
	PUSH R10
	PUSH R11
	MOV R1, 0        ;vai limpar os registos 
	MOV R2, 0
	MOV R3, 0
	MOV R4, 0
	MOV R5, 0
	MOV R6, 0
	MOV R7, 0
	MOV R8, 0    
	MOV R9, 0
	MOV R10, 0
	MOV R11, 0
	MOV R1, [DEF_ESTADO_JOGO]           ; vai carregar o estado de jogo atual
    CMP R1, 1                           ; se o jogo estiver em pausa, nao vai fazer o fantasma mexer-se
    JZ FIM_INT_1
	MOV R2, DEF_CORDS_PACMAN_SPAWN      ; carrega as coordenadas do pacman e do fantasma para o mover 
	MOV R9, DEF_CORDS_FANTASMA1_SPAWN        
	CALL MOVE_FANTASMA
	MOV R1, 0
	MOV R2, 0
	MOV R3, 0
	MOV R4, 0
	MOV R5, 0
	MOV R6, 0
	MOV R7, 0
	MOV R8, 0
	MOV R9, 0
	MOV R10, 0
	MOV R11, 0
	MOV R2, DEF_CORDS_PACMAN_SPAWN      
	MOV R9, DEF_CORDS_FANTASMA2_SPAWN   ; carrega as coordenadas do fantasma para o mover 
	CALL MOVE_FANTASMA
	FIM_INT_1:
	POP R11
	POP R10
	POP R9
	POP R8
	POP R7
	POP R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RFE

; *********************************************************************************************************
; CALL_CONTADOR - funcao que dependendo da tecla premida ira aumentar o valor do contador decimal executado
; R3- Endereco do display
; R4- Valor em decimal
; R5- Valor 100
; R6- Endereco da tecla 4
; R7- Endereco da tecla 6
; R11- Valor do contador
; Argumentos: Entrada- R0 / Saida: R3 (DISPLAY)
; *********************************************************************************************************
CALL_CONTADOR:
PUSH R1
PUSH R2
PUSH R3
PUSH R4
PUSH R5
PUSH R6
PUSH R7
PUSH R8
PUSH R9
MOV R5, 100H
MOV R3, DISPLAY ; R3 endereco de display :)
JMP CONTADOR_SOMA
CICLO_CONTADOR:
JMP RETURN_CONTADOR ; Caso a tecla nao esteja premida ele vai retornar

UPDATE_DISPLAY:
    MOV [R3], R11
	JMP  CICLO_CONTADOR

TRANSFORMA_DECIMAL:
    MOV R8, 09AH
    CMP R11, R8
    JZ E_100
    MOV R8, 19AH
    CMP R11, R8
    JZ E_200
    MOV R8, 29AH
    CMP R11, R8                      ;se o numero for 100, 200, 300 etc... , irá inserir esses numeros no display de energia, caso contrario ira converter no respetivo numero decimal 
    JZ E_300
    MOV R8, 39AH
    CMP R11, R8
    JZ E_400
    MOV R8, 49AH
    CMP R11, R8
    JZ E_500
    MOV R8, 59AH
    CMP R11, R8
    JZ E_600
    MOV R8, 69AH
    CMP R11, R8
    JZ E_700
    MOV R8, 79AH
    CMP R11, R8
    JZ E_800
    MOV R8, 89AH
    CMP R11, R8
    JZ E_900
    MOV R8, 0AH
    MOV R9, R11
    AND R9, R8          ; mascara para isolar os bits 
    CMP R9, R8
    JNZ UPDATE_DISPLAY
    ADD R11, 6H          
    JMP UPDATE_DISPLAY


E_100:
    MOV R11, 100H       ; escreve manualmente os numeros respetivos 
    JMP UPDATE_DISPLAY
E_200:
    MOV R11, 200H
    JMP UPDATE_DISPLAY
E_300:
    MOV R11, 300H
    JMP UPDATE_DISPLAY
E_400:
    MOV R11, 400H
    JMP UPDATE_DISPLAY
E_500:
    MOV R11, 500H
    JMP UPDATE_DISPLAY
E_600:
    MOV R11, 600H
    JMP UPDATE_DISPLAY
E_700:
    MOV R11, 700H
    JMP UPDATE_DISPLAY
E_800:
    MOV R11, 800H
    JMP UPDATE_DISPLAY
E_900:
    MOV R11, 900H
    JMP UPDATE_DISPLAY
E_99:
    MOV R11, 99H
    JMP UPDATE_DISPLAY


CONTADOR_SOMA:
    CMP R11, R5 ; vai verificar se o contador esta no limite
    JZ RETURN_CONTADOR
    INC R11     ; se estiver tudo bem irá incrementar o contador 
    JMP TRANSFORMA_DECIMAL

RETURN_CONTADOR:
POP R9
POP R8
POP R7
POP R6
POP R5
POP R4
POP R3
POP R2
POP R1
RET

; **********************************************************************
; CHAMA_TECLADO - Vai fazer um varrimento das teclas e guardar em R0
;
; Argumento : R0 - valor a ser retornado
; "0" - 0011H "1" - 0012H "2" - 0014H "3" - 0018H
; "4" - 0021H "5" - 0022H "6" - 0024H "7" - 0028H
; "8" - 0041H "9" - 0042H "A" - 0044H "B" - 0048H
; "C" - 0081H "D" - 0082H "E" - 0084H "F" - 0088H
; **********************************************************************

SET_KEY_LIN	EQU	0C000H	; Endereço do comando para definir a linha do teclado
GET_KEY_COL	EQU	0E000H	; address of keyboard columns (PIN)
MASCARA	EQU	0FH     ; mask to isolate the last 4 bits of the keyboard columns input

; R8  - BIT flag a representar a linha atual
; R9  - BIT FLAG a representar a coluna atual
; R10 - Valor temporario


CHAMA_TECLADO:
    PUSH R8
    PUSH R9
    PUSH R10
    PUSH R7
    MOV R10, 8 ;BIT FLAG a representar a linha atual
    MOV R8, SET_KEY_LIN
    MOV R7, MASCARA

TECLADO_SHIFT_LINHA:
;Vai percorrer as quatro linhas e apos isso vai dar return
;Vai percorrer as linhas e caso alguma coluna vai guardar
    CMP R10,0
    JZ TECLADO_SEM_INPUT
    MOVB [R8], R10
    MOV R9, GET_KEY_COL
    MOVB R9, [R9]
    AND R9, R7
    CMP R9, 0 ; se existir algum input ele vai saltar para codificar a tecla
    JNZ TECLADO_CODIFICAR
    SHR R10, 1
    JMP TECLADO_SHIFT_LINHA

TECLADO_SEM_INPUT:
    MOV R0, 0       ; se nao receber nenhum input nao ira executar nada 
    JMP TECLADO_RET

TECLADO_CODIFICAR:
    MOV R0, R10; vai passar o numero da linha para o R0
    SHL R0, 4; e vai dar shift para a esquerda para guardar o valor da linha
    OR R0, R9; vai fazer a OR para guardar o valor da coluna

TECLADO_RET:
    POP R7
    POP R10
    POP R9
    POP R8
    RET

; **********************************************************************
; FUNCAO_DELAY: Funcao que vai causar um atraso nas funcoes
;
; Argumento : NONE
;
; **********************************************************************

FUNCAO_DELAY:
	PUSH R2
	MOV R2, TEMPO_DELAY    ; carrega o tempo de delay 

DELAY:
	DEC R2
	CMP R2, 0
	JNZ DELAY
	POP R2
	RET

; **********************************************************************
; FUNCOES_DESENHA: Para desenhar individualmente cada objeto
;
; Argumento : NONE
;
; **********************************************************************

DESENHA_NINHO:
	PUSH R1
	PUSH R9
	MOV R1, DEF_NINHO_PACMAN
	MOV R9, DEF_CORDS_NINHO_SPAWN          ; vai desenhar o ninho nas coordenadas indicadas 
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_DIREITA:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_DIREITA
	MOV R9, DEF_CORDS_PACMAN_SPAWN       ; as funcoes abaixo irao desenhar o pacman em diferentes posicoes (esquerda, direita, cima , baixo, etc..)
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_ESQUERDA:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_ESQUERDA
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_CIMA:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_CIMA
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_BAIXO:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_BAIXO
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_PARADO:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_PARADO
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_DIAGONAL_E_C:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_DIAGONAL_E_C
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_DIAGONAL_E_B:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_DIAGONAL_E_B
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_DIAGONAL_D_C:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_DIAGONAL_D_C
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_PACMAN_DIAGONAL_D_B:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_DIAGONAL_D_B
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_FANTASMA:
	PUSH R1
	PUSH R9
	MOV R1, DEF_FANTASMA         ; vai desenhar os fantasmas 
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_REBUCADO:
	PUSH R1
	PUSH R9
	MOV R1, DEF_REBUCADO    
	CALL CRIAR_BONECO          ;vai desenhar os rebucados 
	POP R9
	POP R1
	RET

; **********************************************************************
; FUNCOES_APAGAR_FIGURA: Para apagar uma figura qualquer
;
; Argumento : R9, coordenadas do boneco
;
; **********************************************************************

APAGAR_BONECO_5X5:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_DIREITA    ; apaga o pacman ou fantasma 
	CALL apagar_boneco
	POP R9
	POP R1
	RET

APAGAR_FRUTA:
	PUSH R1
	PUSH R9
	MOV R1, DEF_REBUCADO     ; apaga o rebucado respetivo
	CALL apagar_boneco
	POP R9
	POP R1
	RET

; **********************************************************************
; FUNCOES_MOVIMENTO: Para repor os valores das coordenadas
;
; Argumento : R9 - coordenadas do boneco
;			  R10 - desenha fantasma ou pacman (0 para fantasma, 1 para pacman)
; **********************************************************************

MOVIMENTO_ESQUERDA:
	PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
    MOV R2, BLUE_L1
    CALL VERIFICAR_COLISAO
	CMP R11, 0
	JZ OBSTACULO_ESQ                   ; as funcoes abaixo irao, primeiramente ver se na proxima posicao desejada ha algum obstaculo presente, apenas ira continuar se a posicao estiver livre  
	CALL APAGAR_BONECO_5X5		        
	MOV R2, [R9]
	SUB R2, 1                          ; vai atualizar as coordenadas do boneco para o nova posicao 
	MOV [R9], R2
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA
	CALL DESENHA_PACMAN_ESQUERDA       ; como a posicao esta livre vai desenhar o boneco na posicao desejada 
	OBSTACULO_ESQ:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_DIREITA:                     ; as funcoes abaixo irao movimentar o pacman na posicao da direcao desejada 
	PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
    MOV R2, BLUE_L1                   ; vai carregar a cor das barreiras para R2
    CALL VERIFICAR_COLISAO            ; verifica se existe colisao na posicao seguinte 
    CMP R11, 0		                  ; compara com a flag do VERFICA_COLISAO
    JZ OBSTACULO_DIR                  ; existe um obstaculo a direita 
	CALL APAGAR_BONECO_5X5            ; apaga o boneco 
	MOV R2, [R9]
	ADD R2, 1
	MOV [R9], R2
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA           ; faz o pre desenho do pacman na posicao seguinte 
	CALL DESENHA_PACMAN_DIREITA       ; desenha o pacman e atualiza as coordenadas 
	OBSTACULO_DIR:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_DIAGONAL_SUPERIOR_ESQUERDA:
    PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
	MOV R2, BLUE_L1       ; carrega o endereco da cor das barreiras 
	CALL VERIFICAR_COLISAO
	CMP R11, 0
	JZ OBSTACULO_DSE
	CALL APAGAR_BONECO_5X5
	MOV R1, R9
    MOVB R2, [R1]      ; carrega a primeira coordenada 
    SUB R2, 1
    MOVB [R1], R2      ; atualiza as coordenadas da posicao para posteriormente desenhar 
    ADD R1, 1
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA    ; vai fazer o pre desenho do fantasma 
	CALL DESENHA_PACMAN_DIAGONAL_E_C
	OBSTACULO_DSE:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_DIAGONAL_SUPERIOR_DIREITA:      ; as funcoes abaixo irao fazer parecido mas com diferentes coordenadas 
	PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
	MOV R2, BLUE_L1                      ; carrega o endereco da cor das barreiras 
	CALL VERIFICAR_COLISAO               ; verifica se nao obstaculos 
    CMP R11, 0
    JZ OBSTACULO_DSD
	CALL APAGAR_BONECO_5X5
	MOV R1, R9
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2                 ; atualiza as coordenadas do fantasma 
    ADD R1, 1
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA
	CALL DESENHA_PACMAN_DIAGONAL_D_C
    OBSTACULO_DSD:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_DIAGONAL_INFERIOR_ESQUERDA:
	PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
	MOV R2, BLUE_L1              ; carrega o endereco da cor das barreiras 
	CALL VERIFICAR_COLISAO
	CMP R11, 0
	JZ OBSTACULO_DIE
	CALL APAGAR_BONECO_5X5
	MOV R1, R9
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2                ; atualiza as coordenadas
    ADD R1, 1
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA
	CALL DESENHA_PACMAN_DIAGONAL_E_B
	OBSTACULO_DIE:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

PRE_DESENHO_FANTASMA:
	POP R11
	POP R9
	POP R2
	POP R1
	JMP DESENHA_FANTASMA        ; vai desenhar o fantasma na posicao respetiva 

MOVIMENTO_DIAGONAL_INFERIOR_DIREITA:
	PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
	MOV R2, BLUE_L1
	CALL VERIFICAR_COLISAO
	CMP R11, 0
	JZ OBSTACULO_DID
	CALL APAGAR_BONECO_5X5
	MOV R1, R9
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2               ; atualiza as coordenadas 
    ADD R1, 1
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA
	CALL DESENHA_PACMAN_DIAGONAL_D_B
	OBSTACULO_DID:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_PARA_CIMA:
	PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
	MOV R2, BLUE_L1             ; carrega o endereco da cor das barreiras 
	CALL VERIFICAR_COLISAO
	CMP R11, 0
	JZ OBSTACULO_CIMA
	CALL APAGAR_BONECO_5X5
	MOV R1, R9
    MOVB R2, [R1]                
    SUB R2, 1
    MOVB [R1], R2               ; atualiza as coordenadas 
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA
	CALL DESENHA_PACMAN_CIMA
	OBSTACULO_CIMA:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_PARA_BAIXO:
	PUSH R1
	PUSH R2
	PUSH R9
	PUSH R11
	MOV R1, R9
	MOV R2, BLUE_L1           ; carrega o endereco da cor das barreiras 
	CALL VERIFICAR_COLISAO
	CMP R11, 0
	JZ OBSTACULO_BAIXO
	CALL APAGAR_BONECO_5X5
	MOV R1, R9
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2             ; atualiza as coordenadas 
	CMP R10, 0
	JZ PRE_DESENHO_FANTASMA
	CALL DESENHA_PACMAN_BAIXO
	OBSTACULO_BAIXO:
	POP R11
	POP R9
	POP R2
	POP R1
	RET

; **********************************************************************
; VERIFICAR_COLISAO: Vai simular a proxima posicao do pacman, para ver se posteriormente ira ocupar um pixel de cor 
;
; Argumento : NONE
; Entrada R0- Input do teclado
;         R1- Endereco posição do boneco
;		  R2- Endereco de cor 
; Saida - R11 0 caso nao possa mexer, 1 caso possa
; **********************************************************************


VERIFICAR_COLISAO:
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV R11, 0         ; inicializacao da flag de verificacao 

	MOVB R3, [R1] ; numero de linha
	ADD R1, 1
	MOVB R4, [R1] ; numero de coluna
	MOV R7, 5     ; contador das linhas 
	MOV R8, 5     ; contador das colunas 


	MOV R5, TECLA_0
	CMP R0, R5               ; as funcoes abaixo irao ver se ha colisao consoante a tecla de movimento premida 
	JZ TECLA_0_COLISAO

	MOV R5, TECLA_1
	CMP R0, R5
	JZ TECLA_1_COLISAO

	MOV R5, TECLA_2
	CMP R0, R5
	JZ TECLA_2_COLISAO

	MOV R5, TECLA_4
	CMP R0, R5
	JZ TECLA_4_COLISAO

	MOV R5, TECLA_6
	CMP R0, R5
	JZ TECLA_6_COLISAO

	MOV R5, TECLA_8
	CMP R0, R5
	JZ TECLA_8_COLISAO

	MOV R5, TECLA_9
	CMP R0, R5
	JZ TECLA_9_COLISAO

	MOV R5, TECLA_A
	CMP R0, R5
	JZ TECLA_A_COLISAO

TECLA_0_COLISAO:
	SUB R4, 1              ; vai mudar as coordenadas para a posicao futura para depois ver se e possivel continuar com o movimento 
	SUB R3, 1
	JMP CICLO_COLISAO

TECLA_1_COLISAO:
	SUB R3, 1
	JMP CICLO_COLISAO

TECLA_2_COLISAO:
	ADD R4, 1
	SUB R3, 1
	JMP CICLO_COLISAO

TECLA_4_COLISAO:
	SUB R4, 1
	JMP CICLO_COLISAO

TECLA_6_COLISAO:
	ADD R4, 1
	JMP CICLO_COLISAO

TECLA_8_COLISAO:
	SUB R4, 1
	ADD R3, 1
	JMP CICLO_COLISAO

TECLA_9_COLISAO:
	ADD R3, 1
	JMP CICLO_COLISAO

TECLA_A_COLISAO:
	ADD R4, 1
	ADD R3, 1
	JMP CICLO_COLISAO

CICLO_COLISAO:
	MOV [DEFINE_COLUNA], R4      ; vai guardar a coordenada da coluna
	MOV [DEFINE_LINHA], R3       ; coordenada da linha 
	MOV R5, [LE_VALOR_PIXEL]     ; vai iniciar um ciclo que verifica as colunas de uma determinada linha e 
	CMP R5, R2
	JZ FIM_VERIFICAR_PIXEL
	SUB R7, 1
	ADD R4, 1
	CMP R7, 0                    ; quando chegar ao fim da linha
	JZ MUDA_LINHA_COLISAO		 ; vai saltar para a linha seguinte 
	JMP CICLO_COLISAO

MUDA_LINHA_COLISAO:
	MOV R7, 5
	SUB R4, 5                     ; volta a primeira coluna da linha escolhida 
	SUB R8, 1                     ; contador das linhas percorridas 
	ADD R3, 1                     ; passa para a proxima linha 
	CMP R8, 0
	JZ COLISAO_VALIDA
	JMP CICLO_COLISAO

COLISAO_VALIDA:
	MOV R11, 1                   ; se nao houver colisao 

FIM_VERIFICAR_PIXEL:
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	RET



; **********************************************************************
; DESENHA_GRELHA: Vai desenhar as grelhas exteriores
;
; Argumento : Não queriamos estar a gastar memoria para fazer a tabela
;
; buraco 14-19 (portais)
; **********************************************************************
LIMITE_COLUNAS EQU 63
LIMITE_LINHAS EQU 31
DESENHA_GRELHA:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
    MOV R3, BLUE_L1 ; R3 cor do pixel
    MOV R4, LIMITE_COLUNAS   ; carrega a ultima linha do ecra 
    MOV R5, LIMITE_LINHAS    ; carrega a ultima coluna do ecra   
	MOV R2, 0 ; COLUNA
	MOV [DEFINE_PIXEL], R3
	MOV R6, 31
	MOV R7, 19

LINHA_COMPLETA:
    ADD R2, 1
    MOV [DEFINE_COLUNA], R2
    MOV [DEFINE_PIXEL], R3
    CMP R2, R4                            ;quando a linha ja foi pintada vai saltar para a proxima 
    JZ ULTIMA_LINHA
    JMP LINHA_COMPLETA

ULTIMA_LINHA:
    CMP R1, R5
    JZ FAZER_MIOLO
    MOV R1, 31 ;linha
    MOV R2, 0
    MOV [DEFINE_LINHA], R1                ; carrega a tabela da linha 
    MOV [DEFINE_COLUNA], R2               ; carrega a tabela da coluna 
    MOV [DEFINE_PIXEL], R3
    JMP LINHA_COMPLETA


FAZER_MIOLO:                 ; vai pintar as linhas da grelha interior que so tem um pixel 
    MOV R1, 1
    MOV R2, 0

PINTAR_MIOLO:
    MOV [DEFINE_LINHA], R1
    ADD R1, 1
    MOV [DEFINE_COLUNA], R2
    MOV [DEFINE_PIXEL], R3   ; vai pintar no primeiro e ultimo pixel da linha respetiva
    MOV [DEFINE_COLUNA], R4     
    MOV [DEFINE_PIXEL], R3
    CMP R1, R6
    JNZ PINTAR_MIOLO
	MOV R1, 13
	MOV R3, 0
	FAZER_PORTAIS:            ; vai remover os pixeis dos portais 
	ADD R1, 1
	MOV [DEFINE_LINHA], R1
	MOV [DEFINE_COLUNA], R2
	MOV [DEFINE_PIXEL], R3
	MOV [DEFINE_COLUNA], R4
	MOV [DEFINE_PIXEL], R3
	CMP R1,R7
	JNZ FAZER_PORTAIS

    POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	RET



; **********************************************************************
; MOVE_FANTASMA: Move o fantasma em direção ao Pacman, atraves da distancia entre as coordenadas linha e coluna entre o fantasma e o pacman 
;
; Argumento : R9 - Tabela com as coordenadas do pacman que se está a mexer
;
;
; **********************************************************************

MOVE_FANTASMA:
	PUSH R0
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R9
	PUSH R11

	MOVB R5, [R9]			; obtém a linha onde o fantasma está
	ADD R9, 1
	MOVB R6, [R9]			; obtém a coluna onde o fantasma está
	SUB R9, 1

	MOV R2, DEF_CORDS_PACMAN_SPAWN
	MOVB R3, [R2]			; obtém a linha onde o pacman está
	ADD R2, 1
	MOVB R4, [R2]			; obtém a coluna onde o pacman está

	CMP R5, R3
	JZ FANTASMA_MESMA_LINHA_PACMAN
	CMP R6, R4
	JZ FANTASMA_MESMA_COLUNA_PACMAN         
	CMP R5, R3
	JN FANTASMA_POR_CIMA_DO_PACMAN
	CMP R5, R3
	JNN FANTASMA_POR_BAIXO_DO_PACMAN


FANTASMA_POR_CIMA_DO_PACMAN:                       ; ira verificar se o fantasma se localiza na mesma coluna ou na mesma linha que o pacman 
	CMP R6, R4
	JN FANTASMA_DIREITA_BAIXO1
	CMP R6, R4
	JNN FANTASMA_ESQUERDA_BAIXO1

FANTASMA_POR_BAIXO_DO_PACMAN:
	CMP R6, R4
	JN FANTASMA_DIREITA_CIMA1
	CMP R6, R4
	JNN FANTASMA_ESQUERDA_CIMA1

FANTASMA_MESMA_LINHA_PACMAN:
	CMP R6, R4
	JN FANTASMA_DIREITA
	CMP R6, R4
	JNN FANTASMA_ESQUERDA

FANTASMA_MESMA_COLUNA_PACMAN:
	CMP R5, R3
	JN FANTASMA_BAIXO
	CMP R5, R3
	JNN FANTASMA_CIMA


FANTASMA_DIREITA_BAIXO1:
	MOV R0, TECLA_A                                  ; passa o endereco da tecla A para o registo 
	CALL MOVIMENTO_DIAGONAL_INFERIOR_DIREITA         ; as funcoes abaixo irao verificar qual o caminho que o fantasma tem de percorrer (diagonal), se o caminho nao for possivel (colisoes) vai percorrer outro caminho valido 
	CMP R11, 0
	JZ FANTASMA_DIREITA_BAIXO2
	JMP RETURN_MOVE_FANTASMA

FANTASMA_DIREITA_BAIXO2:                           
	MOV R0, TECLA_9
	CALL MOVIMENTO_PARA_BAIXO
	CMP R11, 0
	JZ FANTASMA_DIREITA
	JMP RETURN_MOVE_FANTASMA


FANTASMA_ESQUERDA_BAIXO1:
	MOV R0, TECLA_8
	CALL MOVIMENTO_DIAGONAL_INFERIOR_ESQUERDA
	CMP R11, 0
	JZ FANTASMA_ESQUERDA_BAIXO2
	JMP RETURN_MOVE_FANTASMA

FANTASMA_ESQUERDA_BAIXO2:
	MOV R0, TECLA_9
	CALL MOVIMENTO_PARA_BAIXO
	CMP R11, 0
	JZ FANTASMA_ESQUERDA
	JMP RETURN_MOVE_FANTASMA


FANTASMA_DIREITA_CIMA1:
	MOV R0, TECLA_2
	CALL MOVIMENTO_DIAGONAL_SUPERIOR_DIREITA
	CMP R11, 0
	JZ FANTASMA_DIREITA_CIMA2
	JMP RETURN_MOVE_FANTASMA

FANTASMA_DIREITA_CIMA2:
	MOV R0, TECLA_1
	CALL MOVIMENTO_PARA_CIMA
	CMP R11, 0
	JZ FANTASMA_DIREITA
	JMP RETURN_MOVE_FANTASMA


FANTASMA_ESQUERDA_CIMA1:
	MOV R0, TECLA_0
	CALL MOVIMENTO_DIAGONAL_SUPERIOR_ESQUERDA
	CMP R11, 0
	JZ FANTASMA_ESQUERDA_CIMA2
	JMP RETURN_MOVE_FANTASMA

FANTASMA_ESQUERDA_CIMA2:
	MOV R0, TECLA_1
	CALL MOVIMENTO_PARA_CIMA
	CMP R11, 0
	JZ FANTASMA_ESQUERDA
	JMP RETURN_MOVE_FANTASMA


FANTASMA_CIMA:
	MOV R0, TECLA_1
	CALL MOVIMENTO_PARA_CIMA
	JMP RETURN_MOVE_FANTASMA

FANTASMA_BAIXO:
	MOV R0, TECLA_9
	CALL MOVIMENTO_PARA_BAIXO
	JMP RETURN_MOVE_FANTASMA

FANTASMA_DIREITA:
	MOV R0, TECLA_6
	CALL MOVIMENTO_DIREITA
	JMP RETURN_MOVE_FANTASMA

FANTASMA_ESQUERDA:
	MOV R0, TECLA_4
	CALL MOVIMENTO_ESQUERDA
	JMP RETURN_MOVE_FANTASMA

RETURN_MOVE_FANTASMA:
	POP R11
	POP R9
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R0
	RET

; **********************************************************************
; FECHA_NINHO: Fecha o ninho para o pacman nao conseguir voltar a entrar apos ter saido do spawn 
;
; Argumento : Nenhum
;
; **********************************************************************

FECHA_NINHO:

	MOV R3, 8
	MOV R1, DEF_LINHA_FECHA_NINHO       ; carrega a tabela da linha 
	MOV R9, DEF_CORDS_LINHA_FECHA       ; carrega as coordernadas da linha 
	CALL CRIAR_BONECO
	MOV R1, DEF_LINHA_FECHA_NINHO
	MOV R9, DEF_CORDS_LINHA_FECHA
	MOVB R2, [R9]
	ADD R2, R3
    MOVB [R9], R2
	CALL CRIAR_BONECO                              ; vai fechar o ninho com as linhas 
	JMP FIM_DA_FUNC
	POP R9
    POP R4
    POP R3
    POP R2
    POP R1
	RET

FECHAR_OU_NAO:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R9                  
	MOV R1, DEF_ESTADO_NINHO       ; se o pacman ja saiu do ninho, vai fechar o ninho com as linhas desenhadas 
	MOVB R2, [R1]
	CMP R2, 1
	JZ FIM_DA_FUNC

	MOV R3, 9
	MOV R4, 23
	MOV R1, DEF_CORDS_PACMAN_SPAWN
	MOVB R2, [R1]
	CMP R2, R3
	JZ FECHA_NINHO
	CMP R2, R4
	JZ FECHA_NINHO
FIM_DA_FUNC:
	POP R9
	POP R4
	POP R3
	POP R2
	POP R1
	RET

; **********************************************************************
; COME_FRUTA: O pacman quando tocar numa fruta, vai come-la, e essa fruta ira desaparecer do ecra e do historico de frutas
;
; Argumento : R0 - Input da tecla
;
; **********************************************************************

COME_FRUTA:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R9
	PUSH R11

	MOV R1, DEF_CORDS_PACMAN_SPAWN
	MOV R2, RED
	MOV R3, POSICAO_INICIAL_PACMAN_X    ; carrega a coordenada da coluna onde o pacman esta
	MOV R4, POSICAO_INICIAL_PACMAN_Y    ; carrega a coordenada da linha onde o pacman esta 
	CALL VERIFICAR_COLISAO              ; vai verificar se ha colisao entre o pacman e o rebuçado 
	CMP R11, 0                          
	JZ PACMAN_VAI_COMER_FRUTA           ; se a colisao e valida, vai saltar para a funcao referenciada
	JMP RETURN_APAGAR_FRUTA

PACMAN_VAI_COMER_FRUTA:
	MOV R1, DEF_NUMERO_REBUCADOS       ; carrega a tabela com o numero de rebucados atual 
	MOVB R2, [R1]
	CMP R2, 0                          ; vai diminuir o numero de rebucados e vai verificar qual foi comido 
	JZ QUAL_REBUCADO
	SUB R2, 1
	MOV [R1], R2

QUAL_REBUCADO:
	MOV R1, DEF_CORDS_PACMAN_SPAWN
	MOVB R2, [R1]                      ; vai verificar qual foi o rebuçado comido 
	CMP R2, R3
	JLE REBUCADOS_CIMA

	CMP R2, R3
	JGE REBUCADOS_BAIXO

REBUCADOS_BAIXO:                    
	ADD R1, 1                          ; passa para o segundo endereco da coordenada 
	MOVB R2, [R1]                      ; guarda o numero 
	CMP R2, R4                         ; compara o numero com o numero do rebucado 
	JLE REBUCADO2

	CMP R2, R4
	JGE REBUCADO4

REBUCADOS_CIMA:   
	ADD R1, 1                          ; funciona da mesma maneira mas para o outro rebucado 
	MOVB R2, [R1]    
	CMP R2, R4
	JLE REBUCADO1

	CMP R2, R4
	JGE REBUCADO3
   
REBUCADO1:
	MOV R9, DEF_CORDS_REBUCADO1_SPAWN                   ; vai apagar o rebucado respetivo 
	CALL APAGAR_FRUTA                                   ; apaga a fruta 
	JMP RETURN_APAGAR_FRUTA
REBUCADO2:
	MOV R9, DEF_CORDS_REBUCADO2_SPAWN                   ; funciona da mesma maneira mas para as outras frutas respetivas 
	CALL APAGAR_FRUTA
	JMP RETURN_APAGAR_FRUTA
REBUCADO3:
	MOV R9, DEF_CORDS_REBUCADO3_SPAWN            
	CALL APAGAR_FRUTA
	JMP RETURN_APAGAR_FRUTA
REBUCADO4:
	MOV R9, DEF_CORDS_REBUCADO4_SPAWN
	CALL APAGAR_FRUTA
	JMP RETURN_APAGAR_FRUTA


RETURN_APAGAR_FRUTA:
	POP R11
	POP R9
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
