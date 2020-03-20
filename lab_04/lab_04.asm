; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS

; Объявляем сегмент, в который запишем данные (цифру)
; Которую введет пользователь
USER_DATA SEGMENT PARA PUBLIC 'DATA'
	index 		  db 1
	n			  db 1 	; Кол-во строк.
	m			  db 1 	; Кол-во столбцов.
	matrix		  db 81 DUP (0)
				  db   '$'			   
USER_DATA ENDS

DataS   SEGMENT WORD 'DATA'
Message			DB   'input n and m: '  
				DB   '$'			   
DataS   ENDS

; Сегмент кода.
SC1 SEGMENT para public 'CODE'
	; Контролируем правильное обращение к переменным.
	assume CS:SC1, DS:DataS

MULTIPLICATION_N_M:
	assume DS:USER_DATA
	MOV AX, 0h
	MOV CX, 0h
	MOV AL, m
	MUL n
	MOV CX, AX ; В CX лежить m * n.
	RET

INPUT_MATRIX:
	CALL MULTIPLICATION_N_M
	MOV AH, 01h
	MOV BX, 0h
INPUT:
	MOV AH, 01h
	INT 21h	
	MOV matrix[BX], AL
	INT 21h	 ; Для пробела.
	ADD BX, 1h
	LOOP INPUT
	RET

INPUT_NUMERAL:
	MOV AH, 01h
	INT 21h	
	SUB AL, '0'
	RET

PRINT_MATRIX:
	call MULTIPLICATION_N_M ; Перемножает n*m и записывает в CX.
	MOV BX, 0h

PRINT:
	MOV AX, BX
	DIV m 
	CMP AH, 0
	JNE NEXT ; Для \n (когда это нужно).
	MOV AH, 02h
	MOV DL, 10 ; Возврат картеки.
	INT 21h	
	MOV DL, 13 ; \n
	INT 21h	
NEXT: ; (Если m кратно BX (BX - тек. индекс, m - кол-во столбцов))
	MOV AH, 02h
	MOV DL, matrix[BX]
	INT 21h	
	MOV DL, ' '
	INT 21h	

	ADD BX, 1h
	LOOP PRINT
	
	RET

EXIT:
	mov AX, 4c00h
	int 21h
	RET

main:
	; Вывод приветствия. 
	mov   AX,DataS				 
	mov   DS,AX					
	mov   DX,OFFSET Message   
	mov   AH,9					 
	int   21h  

	assume DS:USER_DATA

	mov AX, USER_DATA
	mov DS, AX

	; Считываем кол-во строк. 
	CALL INPUT_NUMERAL
	MOV n, AL

	INT 21h	; Для пробела.

	; Считываем кол-во столбцов. 
	CALL INPUT_NUMERAL
	MOV m, AL

	INT 21h	; Для enter (\n).

	CALL INPUT_MATRIX

	; MOV AH, m
	; mov index, AH


	; TASK
	call MULTIPLICATION_N_M ; Перемножает n*m и записывает в CX.
	MOV BX, 0h

TASK:
	MOV AX, BX
	DIV m 
	CMP matrix[BX], '#'
	JNE SKIP 
	; Если равно '#'
	MOV AH, 02h
	MOV DL, matrix[BX]
	INT 21h	
	MOV DL, ' '
	INT 21h	
	

SKIP: 
	ADD BX, 1h
	LOOP TASK
	

	; Завершение программы.
	CALL EXIT
SC1 ENDS
END main ; Точка входа в программу.