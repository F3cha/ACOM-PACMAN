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
MAX_COLUNA EQU 59          ; número da coluna mais à direita que o objeto pode ocupar
MIN_LINHA  EQU 0		   ; número da linha mais acima que o objeto pode ocupar
MAX_LINHA  EQU 27		   ; número da linha mais abaixo que o objeto pode ocupar
NINHO_DENTRO_MIN_LINHA EQU 14
NINHO_DENTRO_MAX_LINHA EQU 18
NINHO_FORA_MIN_LINHA EQU 10
NINHO_FORA_MAX_LINHA EQU 22
NINHO_DENTRO_MIN_COLUNA EQU 24
NINHO_DENTRO_MAX_COLUNA EQU 35
NINHO_FORA_MIN_COLUNA EQU 20
NINHO_FORA_MAX_COLUNA EQU 40
ATRASO EQU 400H	           ; atraso para limitar a velocidade de movimento do boneco
CEM EQU 100H
TEMPO_DELAY EQU 9100H
; --- Teclas --- ;
TECLA_0 EQU 0011H ; Movimento na diagonal superior esquerda
TECLA_1 EQU 0012H; Movimento para cima
TECLA_2 EQU 0014H; Movimento na diagonal superior direita
TECLA_3 EQU 0018H; sem efeito
TECLA_4 EQU 0021H; Movimento para a esquerda
TECLA_5 EQU 0022H; sem efeito
TECLA_6 EQU 0024H; Movimento para a direita
TECLA_7 EQU 0028H; sem efeito
TECLA_8 EQU 0041H; Movimento na diagonal inferior esquerda
TECLA_9 EQU 0042H; Movimento para baixo
TECLA_A EQU 0044H; Movimento na diagonal inferior direita
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
	WORD RED
    BYTE 4
    BYTE 4
    WORD 1, 0, 0, 0
    WORD 0, 1, 1, 0
    WORD 0, 1, 0, 1
    WORD 0, 0, 0, 1

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

DEF_NINHO_PACMAN:
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

DEF_PAR:
    BYTE 0

INT_TABLE:
	WORD	int_0	; Relogio tempo

; *********************************************************************************
; * Programa
; **********************************************************************************
 ; Registos reservados:
 ; R0 - Valor do teclado

 PLACE   0   ; o código tem de começar em 0000H

    MOV R2, 0
	MOV  SP, SP_inicial
	MOV  [APAGA_AVISO], R1			; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1			; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV  [SELECIONA_FUNDO], R1		; muda o cenário de fundo
	MOV BTE, INT_TABLE

	EI
	EI0


	MOV	 R1, 0
	CALL RESET_POSICAO
	CALL DESENHA_NINHO
	CALL DESENHA_PACMAN_PARADO
	CALL DESENHA_FANTASMA1
    CALL DESENHA_FANTASMA2
    JMP ESPERA_TECLADO
    ESPERA_TECLADO_PARADO:
    CALL DESENHA_PACMAN_PARADO
    ESPERA_TECLADO:
    CALL CHAMA_TECLADO
    CMP R0, 0
    JZ ESPERA_TECLADO_PARADO
    MOVIMENTO:
    CMP R0, R2
    JZ MOVIMENTO_DELAY
    MOVIMENTO_CONTINUO:
    CALL EMITIR_1_SOM
    JMP VERIFICA_INPUT
    INICIO:
    MOV R2, R0
    CALL FUNCAO_DELAY
    CALL FUNCAO_DELAY
    JMP ESPERA_TECLADO
    MOVIMENTO_DELAY:
    CALL FUNCAO_DELAY
    CALL FUNCAO_DELAY
    JMP MOVIMENTO_CONTINUO

; **********************************************************************
; CRIAR_BONECO - Desenha um fanstasma na linha e coluna indicadas
;			       com a forma e cor definidas na tabela indicada.
; Argumentos:   R2 - tabela do boneco
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
    MOV R2, TECLA_0
    CMP R0, R2
    JZ TECLA_PRESS_0

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

    JMP INICIO
	
    TECLA_PRESS_0:
	MOV R4, 0FFFFH
	MOV R5, 0FFFFH
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_DIAGONAL_SUPERIOR_ESQUERDA
    JMP INICIO
	
    TECLA_PRESS_1:
	MOV R4, 0FFFFH
	MOV R5, 0H
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_PARA_CIMA
    JMP INICIO
	
    TECLA_PRESS_2:
	MOV R4, 0FFFFH
	MOV R5, 01H
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_DIAGONAL_SUPERIOR_DIREITA
    JMP INICIO
	
    TECLA_PRESS_4:
	MOV R4, 0H
	MOV R5, 0FFFFH
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_ESQUERDA
    JMP INICIO
	
    TECLA_PRESS_6:
	MOV R4, 0H
	MOV R5, 01H
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_DIREITA
    JMP INICIO
	
    TECLA_PRESS_8:
	MOV R4, 01H
	MOV R5, 0FFFFH
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_DIAGONAL_INFERIOR_ESQUERDA
    JMP INICIO
	
    TECLA_PRESS_9:
	MOV R4, 01H
	MOV R5, 0H
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_PARA_BAIXO
    JMP INICIO
	
    TECLA_PRESS_A:
	MOV R4, 01H
	MOV R5, 01H
	CALL VERIFICA_LIMITES
	MOV R4, 0
	MOV R5, 0
    CALL MOVIMENTO_DIAGONAL_INFERIOR_DIREITA
    JMP INICIO


FIM:
	JMP FIM



EMITIR_1_SOM:
    PUSH R9
    MOV R9, 0
    MOV [EMITIR_SOM], R9
    POP R9
    RET
; *********************************************************************************************************
; INterrupcoes
; *********************************************************************************************************
int_0:
    CALL CALL_CONTADOR ; Vai chamar o contador enquanto n\ao apanhar 1 fruta
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
MOV R6, TECLA_4
MOV R7, TECLA_6
JMP CONTADOR_SOMA
CICLO_CONTADOR:
JMP RETURN_CONTADOR ; Caso a tecla nao esteja premida ele vai retornar



UPDATE_DISPLAY:
    MOV [R3], R11
	JMP  CICLO_CONTADOR


TRANSFORMA_DECIMAL_UP:
	MOV R8, 09AH
	CMP R11, R8
	JZ E_100
	MOV R8, 0AH
	MOV R9, R11
	AND R9, R8
	CMP R9, R8
	JNZ UPDATE_DISPLAY
	ADD R11, 6H
	JMP UPDATE_DISPLAY


E_100:
    MOV R11, 100H
    JMP UPDATE_DISPLAY

TRANSFORMA_DECIMAL_DOWN:
    MOV R8, 0FFH
	CMP R11, R8
	JZ E_99
	MOV R8, 0FH
	MOV R9, R11
	AND R9, R8
	CMP R9, R8
	JNZ UPDATE_DISPLAY
	SUB R11, 6H
	JMP UPDATE_DISPLAY

E_99:
    MOV R11, 99H
    JMP UPDATE_DISPLAY


CONTADOR_SOMA:
    CMP R11, R5 ; vai verificar se o contador esta no limite
    JZ RETURN_CONTADOR
    INC R11
    JMP TRANSFORMA_DECIMAL_UP

CONTADOR_SUBTRAI:
    CMP R11, 0 ; vai verificar se o contador esta no limite
    JZ RETURN_CONTADOR
    DEC R11
    JMP TRANSFORMA_DECIMAL_DOWN

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
;Vai percorrer as quatro linhas e apos isso vai dar retun
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
    MOV R0, 0
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
	MOV R2, TEMPO_DELAY
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
	MOV R9, DEF_CORDS_NINHO_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET
	
DESENHA_PACMAN_DIREITA:
	PUSH R1
	PUSH R9
	MOV R1, DEF_PACMAN_DIREITA
	MOV R9, DEF_CORDS_PACMAN_SPAWN
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

DESENHA_FANTASMA1:
	PUSH R1
	PUSH R9
	MOV R1, DEF_FANTASMA
	MOV R9, DEF_CORDS_FANTASMA1_SPAWN
	CALL CRIAR_BONECO
	POP R9
	POP R1
	RET

DESENHA_FANTASMA2:
	PUSH R1
	PUSH R9
	MOV R1, DEF_FANTASMA
	MOV R9, DEF_CORDS_FANTASMA2_SPAWN
	CALL CRIAR_BONECO
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
	MOV R1, DEF_PACMAN_DIREITA
	CALL apagar_boneco
	POP R9
	POP R1
	RET

; **********************************************************************
; FUNCOES_MOVIMENTO: Para repor os valores das coordenadas
;
; Argumento : NONE
;
; **********************************************************************
MOVIMENTO_ESQUERDA:
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R2, [DEF_CORDS_PACMAN_SPAWN]
	SUB R2, 1
	MOV [DEF_CORDS_PACMAN_SPAWN], R2
	CALL DESENHA_PACMAN_ESQUERDA
	POP R9
	POP R2
	RET

MOVIMENTO_DIREITA:
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R2, [DEF_CORDS_PACMAN_SPAWN]
	ADD R2, 1
	MOV [DEF_CORDS_PACMAN_SPAWN], R2
	CALL DESENHA_PACMAN_DIREITA
	POP R9
	POP R2
	RET

MOVIMENTO_DIAGONAL_SUPERIOR_ESQUERDA:
    PUSH R1
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R1, DEF_CORDS_PACMAN_SPAWN
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2
	
    ADD R1, 1
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2
	CALL DESENHA_PACMAN_DIAGONAL_E_C
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_DIAGONAL_SUPERIOR_DIREITA:
    PUSH R1
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R1, DEF_CORDS_PACMAN_SPAWN
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2
	
    ADD R1, 1
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2
	CALL DESENHA_PACMAN_DIAGONAL_D_C
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_DIAGONAL_INFERIOR_ESQUERDA:
    PUSH R1
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R1, DEF_CORDS_PACMAN_SPAWN
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2

    ADD R1, 1
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2
	CALL DESENHA_PACMAN_DIAGONAL_E_B
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_DIAGONAL_INFERIOR_DIREITA:
    PUSH R1
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R1, DEF_CORDS_PACMAN_SPAWN
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2
    ADD R1, 1
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2
	CALL DESENHA_PACMAN_DIAGONAL_D_B
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_PARA_CIMA:
	PUSH R1
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R1, DEF_CORDS_PACMAN_SPAWN
    MOVB R2, [R1]
    SUB R2, 1
    MOVB [R1], R2
	CALL DESENHA_PACMAN_CIMA
	POP R9
	POP R2
	POP R1
	RET

MOVIMENTO_PARA_BAIXO:
	PUSH R1
	PUSH R2
	PUSH R9
	MOV R9, DEF_CORDS_PACMAN_SPAWN
	CALL APAGAR_BONECO_5X5
	MOV R1, DEF_CORDS_PACMAN_SPAWN
    MOVB R2, [R1]
    ADD R2, 1
    MOVB [R1], R2
	CALL DESENHA_PACMAN_BAIXO
	POP R9
	POP R2
	POP R1
	RET

; **********************************************************************
; RESET_POSICAO: Para repor os valores das coordenadas
;
; Argumento : NONE
;
; **********************************************************************

RESET_POSICAO:
	PUSH R1
	PUSH R2
	MOV R1, DEF_CORDS_PACMAN_SPAWN
	MOV R2, 010H
	MOVB [R1], R2
	ADD R1, 1
	MOV R2, 1EH
	MOVB [R1], R2
	POP R2
	POP R1
	RET

; **********************************************************************
; VERIFICA_LIMITES: Verifica se o boneco chegou aos limites (ninho e bordas da tela)
;
; Argumentos : R4 - vai subir, descer ou permanecer na mesma linha (0, 1, -1)
;			   R5 - vai para a esquerda, diretia ou permanecer na mesma coluna (0, 1, -1)
;
; **********************************************************************

VERIFICA_LIMITES:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	
	MOV R1, DEF_CORDS_PACMAN_SPAWN		; colocar as coordenadas do pacman nos registos R2 e R3
	MOVB R2, [R1]					
	ADD R1, 1
	MOVB R3, [R1]
	
	ADD R2, R4							; adicionar aos registos com as coordenadas, a possivel nova coordenada de movimento
	ADD R3, R5
	
	MOV R6, MIN_LINHA					; verifica se chegou ao limite superior ou inferior da tela
	MOV R7, MAX_LINHA
	CMP R2, R6
	JZ MOVIMENTO_INVALIDO
	CMP R2, R7
	JZ MOVIMENTO_INVALIDO
	
	MOV R6, MIN_COLUNA					; verifca se chegou aos limites laterais da tela
	MOV R7, MAX_COLUNA
	CMP R3, R6
	JZ MOVIMENTO_INVALIDO
	CMP R3, R7
	JZ MOVIMENTO_INVALIDO
		
	;JMP MOVIMENTO_VALIDO
	
	MOV R6, NINHO_FORA_MIN_LINHA
	MOV R7, NINHO_FORA_MAX_LINHA 
	CMP R2, R6 
	JGE CONFIRMA_ENTRE_LINHAS
	JMP CONFIRMA_ENTRE_COLUNAS
	
CONFIRMA_ENTRE_LINHAS:
	CMP R2, R7
	JLE LIMITES_LATERAIS_NINHO
	JMP CONFIRMA_ENTRE_COLUNAS
	
CONFIRMA_ENTRE_COLUNAS:
	MOV R6, NINHO_FORA_MIN_COLUNA
	MOV R7, NINHO_FORA_MAX_COLUNA
	CMP R2, R6
	JGE CONFIRMA_ENTRE_COLUNAS
	CMP R2, R7
	JLE LIMITES_HORIZONTAIS_NINHO
	
LIMITES_LATERAIS_NINHO:
	
	
	
	
	JMP CONFIRMA_ENTRE_COLUNAS
	
LIMITES_HORIZONTAIS_NINHO:
	
	
	
	
	
	JMP MOVIMENTO_VALIDO	
	
MOVIMENTO_INVALIDO:
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	JMP INICIO
	
MOVIMENTO_VALIDO:
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	JMP return