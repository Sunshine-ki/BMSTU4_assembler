StkSeg  SEGMENT PARA STACK 'STACK'
        DB      200h DUP (?)
StkSeg  ENDS

DS2 SEGMENT PARA PUBLIC 'DATA'
	symb LABEL word
DS2 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, es:DS2
main:

	; Делает прерываение для выхода.
	MOV AX, 4c00h
	INT 21h
SC1 ENDS
END main ; Точка входа в программу.