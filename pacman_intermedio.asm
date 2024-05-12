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
BLUE		EQU 0F026H

; --- Limites --- ;
MIN_COLUNA EQU 0		   ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA EQU 63        ; número da coluna mais à direita que o objeto pode ocupar
ATRASO EQU 400H	   ; atraso para limitar a velocidade de movimento do boneco

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
							
DEF_FANTASMA:			    ; tabela que define o boneco (cor, largura, pixels)
	WORD 16
	WORD 0
	WORD 4H
	WORD 4H
	WORD 0, GREEN, GREEN, 0, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, 0, 0, GREEN		; # # #   as cores podem ser diferentes
 
 DEF_PACMAN_PARADO:
	WORD 16
	WORD 60
	WORD 4H
	WORD 5H
	WORD 0, YELLOW, YELLOW, 0, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, 0, YELLOW, YELLOW, 0
	
 DEF_PACMAN_ANDAR:
	WORD 16
	WORD 30
	WORD 4H
	WORD 5H
	WORD 0, YELLOW, YELLOW, 0, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, 0, 0, 0, YELLOW, YELLOW, YELLOW, YELLOW, 0, YELLOW, YELLOW, 0
	
; *********************************************************************************
; * Programa
; *********************************************************************************
 ; Registos reservados:
 ; R0 - Valor do teclado

 PLACE   0                     ; o código tem de começar em 0000H
iniciar:
    MOV R2, 0
	MOV  SP, SP_inicial
	MOV  [APAGA_AVISO], R1			; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1			; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV  [SELECIONA_FUNDO], R1		; muda o cenário de fundo
	MOV	 R1, 0
inicio:
	MOV R1, DEF_PACMAN_PARADO		; chama funcao cria_boneco com argumento o pacman parado
	CALL criar_boneco
	MOV R1, 0
	
	MOV R1, DEF_PACMAN_ANDAR		; chama funcao cria_boneco com argumento o pacman a andar
	CALL criar_boneco
	MOV R1, 0
	
	MOV R1, DEF_FANTASMA            ; chama funcao cria_boneco com argumento o fantasma
	CALL criar_boneco
	MOV R1, 0
	Movimento:
	CALL CHAMA_TECLADO ;VAI corre um loop ate a tecla nao ser a mesma
	CMP R0, R2
	JZ Movimento
	CMP R0, 0; chama funcao teclado, ainda nao percebemos a parte da tecla coninua
	JNZ VERIFICA_INPUT
	INPUT_VERIFICADO: MOV R2, R0
	JMP inicio

; **********************************************************************
; CRIAR_BONECO - Desenha um fanstasma na linha e coluna indicadas
;			       com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - tabela que define o boneco
; **********************************************************************	
criar_boneco:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	
	MOV R2, [R1]			; obtém a linha onde será desenhado o boneco
	ADD R1, 2
	MOV R3, [R1]			; obtém a coluna onde será desenhado o boneco
	ADD R1, 2
	MOV	R4, [R1]            ; obtém a largura do boneco
	MOV R7, [R1]			; guarda a largura do boneco
	ADD R1, 2
	MOV R5, [R1]			; obtém a altura do boneco
	ADD R1, 2
	
desenha_boneco:
	MOV R6, [R1]			; obtém a cor do proximo pixel
	CALL escreve_pixel	
	ADD R1, 2				; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R3, 1          		; próxima coluna
    SUB R4, 1				; menos uma coluna para tratar
    JNZ desenha_boneco    	; continua até percorrer toda a largura do objeto
	MOV R4, R7				
	SUB R5, 1
	JNZ muda_linhas			; muda para a proxima linha
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
	JMP desenha_boneco

escreve_pixel:
	MOV [DEFINE_LINHA], R2		; seleciona a linha
	MOV [DEFINE_COLUNA], R3		; seleciona a coluna
	MOV [DEFINE_PIXEL], R6		; altera a cor do pixel na linha e coluna já selecionadas
	RET
; **********************************************************************
; VERIFICA_INPUT- Vai reagir a tecla pressionada
; **********************************************************************
VERIFICA_INPUT:
    MOV R2, TECLA_E
    CMP R0, R2
    JZ fim

    MOV R2, TECLA_C
    CMP R0, R2
    JZ EMITIR_1_SOM
    JMP inicio


EMITIR_1_SOM:
    MOV R9, 0
    MOV [EMITIR_SOM], R9
    JMP Movimento


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
    PUSH R11
    MOV R10, 8 ;BIT FLAG a representar a linha atual
    MOV R8, SET_KEY_LIN
    MOV R11, MASCARA

TECLADO_SHIFT_LINHA:
;Vai percorrer as quatro linhas e apos isso vai dar retun
;Vai percorrer as linhas e caso alguma coluna vai guardar
    CMP R10,0
    JZ TECLADO_SEM_INPUT
    MOVB [R8], R10
    MOV R9, GET_KEY_COL
    MOVB R9, [R9]
    AND R9, R11
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
    POP R11
    POP R10
    POP R9
    POP R8
    RET
fim:
	JMP fim