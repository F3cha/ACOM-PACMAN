; *********************************************************************************
; * IST-UL
; * Modulo:    pacman_intermedio.asm
; * Descrição: Este programa tem como objetivo ilustrar fantasmas no ecrã.
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************

DEFINE_LINHA    EQU 600AH      ; endereço do comando para definir a linha
DEFINE_COLUNA   EQU 600CH      ; endereço do comando para definir a coluna
DEFINE_PIXEL    EQU 6012H      ; endereço do comando para escrever um pixel
APAGA_AVISO     EQU 6040H      ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ      EQU 6002H      ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_FUNDO EQU 6042H      ; ender eço do comando para selecionar uma imagem de fundo

LINHA EQU 16         ; linha do boneco (a meio do ecrã))
COLUNA EQU 30         ; coluna do boneco (a meio do ecrã)

LARGURA	EQU	4		   ; largura do fanstama
ALTURA EQU 4          ; altura do fanstasma
COR_PIXEL EQU 0FF00H	   ; cor do pixel interior: verde em ARG

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

MIN_COLUNA EQU 0		   ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA EQU 63        ; número da coluna mais à direita que o objeto pode ocupar
ATRASO EQU 400H	   ; atraso para limitar a velocidade de movimento do boneco

; *********************************************************************************
; * DATA
; *********************************************************************************
	PLACE 1000H
pilha:
	STACK 100H			; espaço reservado para a pilha 
						; (200H bytes, pois são 100H words)
SP_inicial:				; este é o endereço (1200H) com que o SP deve ser 
						; inicializado. O 1.º end. de retorno será 
						; armazenado em 11FEH (1200H-2)
							
<<<<<<< HEAD
DEF_FANTASMA:			    ; tabela que define o boneco (cor, largura, pixels)
	WORD 4H
	WORD 4H
	WORD 0, GREEN, GREEN, 0, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, 0, 0, GREEN		; # # #   as cores podem ser diferentes
 
 DEF_PACMAN_PARADO:
	WORD 4H
	WORD 5H
	WORD 0, YELLOW, YELLOW, 0, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, 0, YELLOW, YELLOW, 0
	
 DEF_PACMAN_ANDAR:
	WORD 4H
	WORD 5H
	WORD 0, YELLOW, YELLOW, 0, YELLOW, YELLOW, YELLOW, YELLOW, YELLOW, 0, 0, 0, YELLOW, YELLOW, YELLOW, YELLOW, 0, YELLOW, YELLOW, 0
	
=======
DEF_BONECO:			    ; tabela que define o boneco (cor, largura, pixels)
	WORD LARGURA
	WORD ALTURA
	WORD 0, GREEN, GREEN, 0, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, GREEN, 0, 0, GREEN		; # # #   as cores podem ser diferentes
     

>>>>>>> 5c58f7dab36eb674c2d2346a2ebcabf85e94c344
; *********************************************************************************
; * Código
; *********************************************************************************
    PLACE   0                     ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial
	MOV  [APAGA_AVISO], R1	; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1	; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
<<<<<<< HEAD
	MOV  [SELECIONA_FUNDO], R1
	MOV	 R1, 0			    ; cenário de fundo número 0
	
	MOV R1, LINHA			; linha de spawn do fantasma
	MOV R2, COLUNA		    ; coluna de spawn do fantasma
	MOV R3, DEF_PACMAN_PARADO
	
	CALL criar_boneco
=======
	MOV	 R1, 0			    ; cenário de fundo número 0
	CALL criar_fantasma
>>>>>>> 5c58f7dab36eb674c2d2346a2ebcabf85e94c344

; **********************************************************************
; DESENHA_BONECO - Desenha um fanstasma na linha e coluna indicadas
;			       com a forma e cor definidas na tabela indicada.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - tabela que define o boneco
;
; **********************************************************************	
criar_boneco:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6

	MOV	R4, [R3]			; obtém a largura do fantasma
	ADD R3, 2
	MOV R5, [R3]			; obtém a altura do fantasma
	ADD R3, 2
	
desenha_boneco:
	MOV R6, [R3]
	CALL escreve_pixel
	ADD R3, 2			; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD R2, 1          ; próxima coluna
    SUB R4, 1			; menos uma coluna para tratar
    JNZ desenha_boneco    ; continua até percorrer toda a largura do objeto
	MOV R4, LARGURA
	SUB R5, 1
	JNZ muda_linhas
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	JMP fim
	RET
	
muda_linhas:
	ADD R1, 1
	MOV R2, COLUNA
	JMP desenha_boneco

escreve_pixel:
	MOV [DEFINE_LINHA], R1		; seleciona a linha
	MOV [DEFINE_COLUNA], R2		; seleciona a coluna
	MOV [DEFINE_PIXEL], R6		; altera a cor do pixel na linha e coluna já selecionadas
	RET
		
fim:
	JMP fim