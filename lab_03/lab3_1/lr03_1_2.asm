PUBLIC output_X
EXTRN X: byte

DS2 SEGMENT AT 0b800h
	CA LABEL byte
	; ORG 80
	ORG 80 * 2 * 2 + 2 * 2 ; 324 (144 в 16-ой)
	SYMB LABEL word
DS2 ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG , ES:DS2
output_X proc near ; Процедура (Описание).
	mov ax, DS2
	mov es, ax
	mov ah, 10 ; 1010
	mov al, X
	; mov ES:symb, ax
	mov symb, ax

	; MOV ah, 2h
	; MOV dl, 'R'
	; int 21h

	ret
output_X endp ; Конец процедуры.
CSEG ENDS
END