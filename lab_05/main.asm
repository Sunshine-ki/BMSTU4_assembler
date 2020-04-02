SC1 SEGMENT para public 'CODE'
	; assume CS:SC2, DS:DataMessage
; Делает прерываение для выхода.
exit:
	mov AX, 4c00h
	int 21h
	
SC1 ENDS

SC1 SEGMENT para public 'CODE'
	; assume CS:SC2, DS:DataMessage
INPUT_NUMBER:
	mov   AX, 1		 

	RET

SC1 ENDS


SC1 SEGMENT para public 'CODE'
	; assume CS:SC2, DS:DataMessage
OUTPUT_BINARY_NUMBER:
	mov   AX, 2				 

	RET

SC1 ENDS

SC1 SEGMENT para public 'CODE'
	; assume CS:SC2, DS:DataMessage
OUTPUT_OCTAL_NUMBER:
	mov   AX, 3			 

	RET

SC1 ENDS

; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	DB 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS

DATA SEGMENT PARA PUBLIC 'DATA'
	number DB 4 DUP ('!') 
	array  DW  exit, INPUT_NUMBER, OUTPUT_BINARY_NUMBER, OUTPUT_OCTAL_NUMBER 	
		   DB 4 DUP ('!') 

	; Т.к. масимальное число это FFFF.

DATA ENDS

; Сообщение пользователю.
DataMessage   SEGMENT WORD 'DATA'
Message			DB    10, 13, 5 DUP (' '), 'Menu: ', 10, 13
				DB   '1. Input number.' , 10, 13
				DB   '2. Number output in 2 number system.', 10, 13   
				DB   '3. Number output in 8 number system.', 10, 13  
				DB   '0. Exit.', 10, 13, 10  
				DB	 'Select an action: '
				DB   '$'	
Message_error	DB 	  10, 13, 'Input Error!', 10, 13, '$'
DataMessage   ENDS





SC1 SEGMENT para public 'CODE'
	; Контролируем правильное обращение к переменным.
	assume CS:SC1, DS:DataMessage

input_error:
assume DS:DataMessage
	mov   AX, DataMessage				 
	mov   DS, AX
	mov   DX, OFFSET Message_error
	mov   AH, 9					 
	int   21h  

main:
	; Вывод меню. 
	mov   AX, DataMessage				 
	mov   DS, AX					
	mov   DX, OFFSET Message   
	mov   AH, 9					 
	int   21h  

assume DS:DATA
	mov   AX, DATA
	mov   DS, AX

	MOV AH, 01h
	INT 21h	

	; Проверка корректного ввода.
	CMP AL, '3'
	JA input_error
	CMP AL, '0'
	JB input_error

	SUB AL, '0' ; Перевод в цифру.

	MOV BL, 2
	MUL BL

	MOV SI, AX
	MOV AX,  array[SI]	 

	CALL AX
	jmp main
SC1 ENDS
END main ; Точка входа в программу.