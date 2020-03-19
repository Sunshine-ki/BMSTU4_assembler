; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS

; Объявляем сегмент, в который запишем данные (цифру)
; Которую введет пользователь
USER_DATA SEGMENT PARA PUBLIC 'DATA'
	index		  db 1
    n             db 1 	; Кол-во строк.
    m             db 1 	; Кол-во столбцов.
    matrix        db 81 DUP (0)
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
    MOV AH, 01h
    INT 21h	

    SUB AL, '0'
	MOV n, AL
	INT 21h	; Для пробела.


	; Считываем кол-во столбцов. 
	; MOV AH, 01h
    ; INT 21h	

	; SUB AL, '0'
	; MOV m, AL

	MOV CL, n
    ; ADD CL, 1

    MOV AH, 01h
	MOV BX, 0h
INPUT_MATRIX:
    MOV AH, 0Ah
    MOV AH, 01h

	INT 21h	
	MOV matrix[BX], AL
	INT 21h	 ; Для пробела.
	ADD BX, 1h
	LOOP INPUT_MATRIX

	MOV CL, n
	MOV BX, 0h
    MOV AH, 02h
PRINT_MATRIX:
	MOV DL, matrix[BX]
	INT 21h	
	MOV DL, ' '
	INT 21h	

	ADD BX, 1h
	LOOP PRINT_MATRIX


	; Завершение программы.
    mov AX, 4c00h
	int 21h
SC1 ENDS
END main ; Точка входа в программу.