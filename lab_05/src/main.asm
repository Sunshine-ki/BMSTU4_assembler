PUBLIC EXIT

EXTRN Message_menu:byte, Message_error:byte
EXTRN array: word

SC1 SEGMENT para public 'CODE'
	assume CS:SC1
input_error:
	MOV AX, seg Message_menu
	MOV DS, AX
	
	MOV DX, OFFSET DS:Message_error
	MOV AH, 9			 
	INT 21h  

main:
	MOV AX, seg Message_menu
	MOV DS, AX
	
	; Вывод меню. 
	MOV DX, OFFSET DS:Message_menu
	MOV AH, 9					 
	INT 21h  

	MOV AX, seg array
	MOV DS, AX

	; Ввод с клавиатуры.
	MOV AH, 01h
	INT 21h	

	; Проверка корректного ввода.
	CMP AL, '3'
	JA input_error
	CMP AL, '0'
	JB input_error

	SUB AL, '0' ; Перевод в цифру.

	; Умножем на 2, потому что под массив array 
	; Выделено DW, и получается, что команда 1
	; Будет соответствовать array[2]
	; Команда 2 -> array[4] и тд...
	MOV BL, 2
	MUL BL

	; AX - результат умножения.
	MOV SI, AX
	MOV AX,  DS:array[SI] 
	
	; CALL DS:array[SI] 
	
	CALL AX
	JMP main
SC1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1
EXIT proc near
; Делает прерываение для выхода.
	MOV AX, 4c00h
	INT 21h
EXIT endp
SC1 ENDS

END main ; Точка входа в программу.