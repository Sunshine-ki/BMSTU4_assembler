SC1 SEGMENT para public 'CODE'
	; assume CS:SC2, DS:DataMessage
; Делает прерываение для выхода.
exit:
	mov AX, 4c00h
	int 21h
	
SC1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1
INPUT_NUMBER:
assume DS:DataMessage
	mov   AX, DataMessage				 
	mov   DS, AX
	mov   DX, OFFSET Message_input
	mov   AH, 9					 
	int   21h  

assume DS:DATA
	MOV CX, 5 
	MOV BX, 0h
	INPUT:
	; Записываем специальный символ в следующее
	; Значение, чтобы знать, где конец числа. 
	MOV number[BX + 1], '$'
	; Считываем символ и помещаем в number[BX].
	; BX на каждом шаге увеличиваем на единицу. 
	MOV AH, 01h
	INT 21h	

	CMP AL, 0Dh ; Это \n 
	; Если пользователь ввел \n, то:
	JE main

	CMP AL, '9'
	JA t1
	SUB AL, '0'
	jmp write

t1:
	SUB AL, 40h
	ADD AL, 9H 

write:
	MOV number[BX], AL
	INC BX
	LOOP INPUT
	RET

SC1 ENDS


SC1 SEGMENT para public 'CODE'
	assume CS:SC1
OUTPUT_BINARY_NUMBER:
assume DS:DATA
	MOV AH, 02h
	MOV CX, 4 
	MOV BX, 0h
	MOV SI, 0h

	; Выводим \n.
	MOV DL, 10
	INT 21h
	MOV DL, 13
	INT 21h

OUTPUT_B:	
	CMP number[SI], '$'  
	; Если number[SI] == $ (Спец. символу). то:
	JE main

	; MOV DL, number[SI]
	; INT 21h



	MOV BH, number[SI]

	SHL BH, 1
	SHL BH, 1
	SHL BH, 1
	SHL BH, 1
	MOV CX, 4
next_b:
	shl BH, 1
	jc one; Если был перенос
	MOV DL, '0'
	jmp print

one:
	MOV DL, '1'

print:
	MOV AH, 02h
	INT 21h
	cmp BH, 0
	LOOP next_b



	INC SI
	JMP OUTPUT_B	 

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
	number DB 6 DUP ('$') ; Т.к. масимальное число это FFFF.
	array  DW  exit, INPUT_NUMBER, OUTPUT_BINARY_NUMBER, OUTPUT_OCTAL_NUMBER 	
DATA ENDS

; Сообщение пользователю.
DataMessage   SEGMENT WORD 'DATA'
Message_menu	DB    10, 13, 5 DUP (' '), 'Menu: ', 10, 13
				DB   '1. Input number.' , 10, 13
				DB   '2. Number output in 2 number system.', 10, 13   
				DB   '3. Number output in 8 number system.', 10, 13  
				DB   '0. Exit.', 10, 13, 10  
				DB	 'Select an action: '
				DB   '$'	
Message_error	DB 	  10, 13, 'Input Error!', 10, 13, '$'
Message_input	DB	  10, 13, 'Input number: ', '$'		
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
assume DS:DataMessage
	; Вывод меню. 
	mov   AX, DataMessage				 
	mov   DS, AX					
	mov   DX, OFFSET Message_menu   
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