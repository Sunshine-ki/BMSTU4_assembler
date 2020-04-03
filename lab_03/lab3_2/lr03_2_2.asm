SD1 SEGMENT para common 'DATA'
	C1 LABEL byte
	ORG 1h ; смещает одресацию на 1 байт.
	C2 LABEL byte
SD1 ENDS

CSEG SEGMENT para 'CODE'
	ASSUME CS:CSEG, DS:SD1
main:
	mov ax, SD1
	mov ds, ax

	; Выводим символ (Который лежит в dl)
	mov ah, 2
	mov dl, C1
	int 21h

	; Выводим символ (Который лежит в dl)
	mov dl, C2
	int 21h

	mov ax, 4c00h
	int 21h
CSEG ENDS
END main