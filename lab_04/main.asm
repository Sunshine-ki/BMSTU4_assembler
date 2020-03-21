; Задание:
; Заменить символы # на последнюю цифру суммы
; элементов сверху и снизу, если они являются
; цифрами.
; Алгоритм:
; Изначально пользователь вводит
; n и m. После чего заполняет матрицу nxm.
; Далее составляется массив (Длиной m)
; В котором на i-ой позиции
; Стоит сумма i-ого столбца. 
; (i пробегает от 0 до m)
; После того, как массив заполнен
; Пробегаем по всей матрице
; И заменяем решетки на нужную сумму.

; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS

; Объявляем сегмент, в который запишем данные (цифру)
; Которую введет пользователь
DATA SEGMENT PARA PUBLIC 'DATA'
	n			  db 1 	; Кол-во строк.
	m			  db 1 	; Кол-во столбцов.
	matrix		  db 81 DUP (0) ; Матрица.
	flag		  db 1 ; Нужен для того, что бы проверять, есть ли в столбце цифры,
					   ; Если их нет, то оставляем на месте #.
	i 		 	  db 1 ; Вспомогательные переменные для индексации.
	j	 		  db 1 
	sum			  db 1 ; Вспомогательная переменная для подсчета суммы в каждом столбце. 
	array		  db 9 DUP ('#') ; Массив, в котором будет сумма цифр столбцов.			   
DATA ENDS

; Сообщение пользователю.
DataMessage   SEGMENT WORD 'DATA'
Message			DB   'input n and m: '   
				DB   '$'			   
DataMessage   ENDS

; Сегмент кода.
SC1 SEGMENT para public 'CODE'
	; Контролируем правильное обращение к переменным.
	assume CS:SC1, DS:DataMessage
; Перемножает кол-во сткрок на кол-во столбцов 
; И записывает в CX.
MULTIPLICATION_N_M:
	assume DS:DATA
	MOV AX, 0h
	MOV CX, 0h
	MOV AL, m
	MUL n
	MOV CX, AX ; В CX лежить m * n.
	RET

; Ввод матрицы.
INPUT_MATRIX:
	; Перемножаем m на n.
	; Это нужно для счетчика,
	; Чтобы мы знали, сколько итераций
	; Нам нужно сделать.
	CALL MULTIPLICATION_N_M
	MOV AH, 01h
	MOV BX, 0h
INPUT:
	; Считываем символ и помещаем в matrix[BX].
	; BX на каждом шаге увеличиваем на единицу. 
	MOV AH, 01h
	INT 21h	
	MOV matrix[BX], AL
	INT 21h	 ; Для пробела. (Что бы был красивый ввод).
	INC BX
	LOOP INPUT
	RET

; Ввод цифры. Нужно для того, 
; Чтобы заполнить m и n ЦИФРАМИ!
; Чтобы дальше обращаться к m и n 
; Как к цифрам (Чтобы использовать их в счетчиках).  
INPUT_NUMERAL:
	MOV AH, 01h
	INT 21h	
	SUB AL, '0' ; Перевод в цифру.
	RET

; Вывод матртцы (в виде матрицы) на экран.
PRINT_MATRIX:
	CALL MULTIPLICATION_N_M ; Перемножает n*m и записывает в CX.
	MOV BX, 0h

	; Отступ.
	MOV AH, 02h
	MOV DL, 10 ; Возврат картеки.
	INT 21h	
	MOV DL, 13 ; \n
	INT 21h	
	
PRINT:
	; Когда m кратно текущему индексу, то нужно вывести \n.
	MOV AX, BX
	DIV m 
	CMP AH, 0
	JNE NEXT ; Для \n (когда это нужно).
	MOV AH, 02h
	MOV DL, 10 ; Возврат картеки.
	INT 21h	
	MOV DL, 13 ; \n
	INT 21h
; Если m не кратно BX (BX - тек. индекс, m - кол-во столбцов), то мы сразу переходим на данную метку.	
NEXT: 
	MOV AH, 02h
	MOV DL, matrix[BX]
	INT 21h	
	MOV DL, ' ' ; Для красивого вывода (пробелы между цифрами).
	INT 21h	
	INC BX
	LOOP PRINT
	RET


START_TASK:
	; Заполняем массив суммой 
	; Элементов столбцов.
	MOV CX, 0h
	MOV BX, 0H
	MOV CL, n
	MOV j, CL ; Индексная переменная для внуиреннего цикла.
	MOV CL, m
FILL_ARRAY:
	MOV i, CL ; Индексная переменная для внешнего цикла.
	; BL - пробегает от 0 до m.
	MOV BL, m
	SUB BL, i
	MOV CL, j
	MOV SUM, 0h
	MOV flag, 0 
	; Флаг нужен для того, чтобы отследить,
	; тот случай, когда в столбце нет цифр
	; Тогда мы оставляем #. 
INNER_LOOP:
	; Проверяем, является ли символ цифрой.
	; То есть если он меньше нуля
	; Или больше 9, то мы отправляем его 
	; На метку NEXT2, иначе
	; Меняем флаг на истину
	; И считаем увеличиваем сумму. 
	CMP matrix[BX], '9'
	JA NEXT2
	CMP matrix[BX], '0'
	JB NEXT2

	MOV flag, 1
	MOV AL, matrix[BX]
	SUB AL, '0' ; Преобразуем в цифру.
	ADD SUM, AL ; Прибавляем к сумме.
	CMP SUM, 10 ; Проверяем, был ли перенос.
	JL NEXT2 ;  ; Если меньше, то переходим на метку NEXT2.
	; Если был перенос (Т.е. сумма больше 9)
	SUB SUM, 10 ; То вычитаем из суммы 10 (Тем самым получаем последнюю цифру) 

NEXT2:
	ADD BL, m ; Продолжаем цикл.
	LOOP INNER_LOOP

	ADD SUM, '0' ; Переводим получившуюся сумму в число, понятное нам. 

	CMP flag, 0
	; Если флаг не менялся, значит нет цифр в
	; Cтолбце и мы переходим на метку NEXT3.
	JE NEXT3  
	; Инече записываем сумму в массив.
	MOV AX, 0
	MOV AL, m
	SUB AL, i
	MOV SI, AX
	MOV AH, SUM
	MOV array[SI], AH
NEXT3:
	MOV CL, i
	LOOP FILL_ARRAY


; ; print_array
; 	MOV CX, 0
; 	MOV BX, 0
; 	MOV CL, m
; PRINT_ARRAY:
; 	MOV AH, 02h
; 	MOV DL, array[BX]
; 	INT 21h	
; 	MOV DL, ' '
; 	INT 21h	
; 	INC BX
; 	LOOP PRINT_ARRAY


	; TASK
	CALL MULTIPLICATION_N_M ; Перемножает n*m и записывает в CX.
	MOV BX, 0h
TASK:
	; Итерируемся по всему массиву.
	MOV AX, BX
	DIV m 
	; Проверяем, равен ли текущий элемент решетке.
	CMP matrix[BX], '#'
	; Если не равен, то переходим на метку SKIP.  
	JNE SKIP 
	; Если равно '#'
	; То узнаем, по какому идексу в массиве лежит 
	; Сумма и записываем эту сумму.
	; Узнаем индекс, при помощи нахождения 
	; Остатка от деления текущего элемента на m.
	MOV AX, BX
	DIV m
	XCHG AL, AH
	MOV AH, 0
	MOV SI, AX
	MOV AL, array[SI]
	MOV matrix[BX], AL	
SKIP: 
	INC BX
	LOOP TASK

	RET


; Делает прерываение для выхода.
EXIT:
	mov AX, 4c00h
	int 21h
	RET

; Главная функция. С нее начинается программа.
main:
	; Вывод приветствия. 
	mov   AX,DataMessage				 
	mov   DS,AX					
	mov   DX,OFFSET Message   
	mov   AH,9					 
	int   21h  

	; Теперь мы работаем с матрицей.
	assume DS:DATA
	mov AX, DATA
	mov DS, AX

	; Считываем кол-во строк. 
	CALL INPUT_NUMERAL
	MOV n, AL
	INT 21h	; Для пробела.

	; Считываем кол-во столбцов. 
	CALL INPUT_NUMERAL
	MOV m, AL
	INT 21h	; Для enter (\n).

	; Ввод матрицы.
	CALL INPUT_MATRIX

	; Выполняем задание.
	CALL START_TASK
	
	; Выводим матрицу.
	CALL PRINT_MATRIX

	; Завершение программы.
	CALL EXIT
SC1 ENDS
END main ; Точка входа в программу.