; EXTRN INPUT_NUMBER: near

PUBLIC Message_input, number

SC1 SEGMENT para public 'CODE'
	assume CS:SC1
EXIT:
; Делает прерываение для выхода.
	MOV AX, 4c00h
	INT 21h
SC1 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1
; Ввод числа в 16 с.с.
INPUT_NUMBER proc near ; Процедура (Описание).
assume DS:DataMessage
; Выводим сообщение о просьбе ввести число.
	MOV   AX, DataMessage				 
	MOV   DS, AX
	MOV   DX, OFFSET Message_input
	MOV   AH, 9					 
	INT   21h  

assume DS:DATA
	MOV   AX, DATA
	MOV   DS, AX

	; Т.к. пользователь может ввести только 
	; FFFF и Enter. 
	MOV CX, 5 
	; Зануляем BX.
	XOR BX, BX 
	INPUT:
	; Записываем специальный символ в следующее
	; Значение, чтобы знать, где конец числа. 
	MOV number[BX + 1], '$'
	; Считываем символ 
	MOV AH, 01h
	INT 21h	

	CMP AL, 0Dh ; Это \n 
	; Если пользователь ввел \n, то 
	; Возвращаемя в main
	JE END_INPUT

	; Сравниваем введеное значение с 9.
	CMP AL, '9'
	JA t1
	; Если меньше 9, то вычитаем '0'
	; И переходим к записи значения в массив.
	SUB AL, '0'
	JMP write

t1:
	; Если больше 9 (Т.е. A,B,...,F)
	; То
	SUB AL, 40h
	ADD AL, 9H 

write:
	; Помещаем , введеное пользователем
	; значениев в number[BX].
	MOV number[BX], AL
	; BX на каждом шаге увеличиваем на единицу. 
	INC BX
	LOOP INPUT
END_INPUT:
	RET
INPUT_NUMBER endp ; Конец процедуры.
SC1 ENDS


SC1 SEGMENT para public 'CODE'
	assume CS:SC1
OUTPUT_BINARY_NUMBER:
assume DS:DATA
	MOV   AX, DATA		 
	MOV   DS, AX

	MOV CX, 4 ; Т.к. максимальное это FFFF.
	XOR BX, BX
	XOR SI, SI

	; Выводим \n.
	MOV AH, 02h
	MOV DL, 10
	INT 21h
	MOV DL, 13
	INT 21h

OUTPUT_B:	
	CMP number[SI], '$'  
	; Если number[SI] == $ (Спец. символу),
	; То возвращаемся в main.
	JE END_OUTPUT_BINARY

	MOV BH, number[SI]

	; Сдвигаем BH влево на 4.
	; Это привелет к тому, что мы подвинем
	; значение на один бит влево.
	; Было: 0F Станет: F0.
	; Это нам нужно, потому что
	; Числа в массиве хранятся данным образом:
	; Записано значение в младшем бите,
	; Т.е. все числа там записаны от 00 (0) до 0F (15).
	MOV CL, 4
	SHL BH, CL
	MOV CL, 0

	; Теперь нам нужно вывести само 
	; Значение в 2-ом с.с., для этого
	; Мы сдвигаем значение 4 раза влево и
	; Во время каждого сдвига проверяем:
	; Если был перенос (Т.е. там была единица)
	; То выводим единицу.
	; Иначе там был ноль (Выводим ноль).
	; Пример: F представляется как 1111,
	; Тогда каждый раз, когда мы сдвигаем его влево 
	; У нас происходит перенос, мы это замечаем и выводим единицу.
	; Если же переноса не было - выводим ноль.
	MOV CX, 4
next_b:
	; Сдвигаем влево. 
	SHL BH, 1
	JC one
	; Если не было переноса (Помещаем в DL '0').
	MOV DL, '0'
	; Переходим к выводу.
	JMP print

one:
	; Если был перенос (Помещаем в DL '1').
	MOV DL, '1'

print:
	; Выводим то, что лежит в DL.
	MOV AH, 02h
	INT 21h
	LOOP next_b

	; Увеличиваем SI (Чтобы получить след. значение)
	INC SI
	JMP OUTPUT_B	 

END_OUTPUT_BINARY:
	RET
SC1 ENDS


SC1 SEGMENT para public 'CODE'
	assume CS:SC1
OUTPUT_OCTAL_NUMBER:
assume DS:DATA
	MOV   AX, DATA		 
	MOV   DS, AX

	MOV CX, 4 
	XOR BX, BX
	XOR SI, SI

	; Выводим \n.
	MOV AH, 02h
	MOV DL, 10
	INT 21h
	MOV DL, 13
	INT 21h

    XOR AX, AX
	XOR DX, DX

	CMP number[SI], '$'  
	; Если number[SI] == $ (Спец. символу). то:
	JE END_OUTPUT_OCTAL

	MOV AL, number[SI]
	; Переводим в регистр (AX), то
	; Что лежит в массиве.
	; В массиве символы
	; Записанны данным образом: 
	; 0F 01 0A $
	; Тогда мы итерируемся 
	; (Каждый раз увеличиваем SI)
	; По массиву до тех пор, пока что
	; Не встретим '$'.
	; В начале регистр выглядит следующим образом:
	; В AX лежит лежит первый символ из массива
	; 000X (Где X это 01 or 02 or ... or 0F)
	; Если в массиве есть еще символы,
	; То мы сдвигаем регистр (AX) 4 раза влево
	; Получаем 00X0
	; И к нему прибавляем, то, что лежит на 
	; Данной итерации в массиве, т.е.
	; 00X0 + 000Y = 00XY, Где X и Y значения массива. 
	; В итоге в регистре AX лежит значение, которое ввел пользователь.
translation:
	INC SI
	CMP number[SI], '$'  
	JE break
	MOV CL, 4
	SHL AX, CL
	MOV	DL, number[SI]
	ADD AX, DX
	JMP translation

	; Вывод числа в 8 с.с. (С помощью стека) 
break:
    XOR CX, CX
    MOV BX, 8 ; основание с.c.
division:
	; Т.к. мы делим на регистр из 2 байт(BX)
	; То деление будет происходить следующим образом:
	; Процессор поделит число, старшие биты которого 
	; Хранит регистр dx, а младшие ax на значение,
	; Хранящееся в регистре bx.
	; Поэтому значение DX нам нужно занулить 
	; (Тогда при делении будет участвовать только AX).
    XOR DX, DX
	; Делим число (AX) на основание с.с. (BX).
    DIV BX
	; Результат от деления запишется в регистр AX.
	; В стек помещаем остаток (DX).
    PUSH DX
	; Увеличиваем CX 
	; Счетчик нужен для того, чтобы знать
	; Сколько потом цифр выводить (Брать из стека).
    INC CX

	; Команда TEST выполняет логическое И между
	; Всеми битами двух операндов. Результат никуда не 
	; Записывается, команда влияет только на флаги.
	; ZF будет установлен только в том случае
	; Если все биты равны 0 (Результат)
    TEST AX, AX
	; ZF - флаг/признак нулевого результата (Zero),
	; Устанавливается в 1, если получен нулевой результат, иначе (ZF)=0.
    JNZ division ; ZF != 0 (Если не ноль, продолжаем деление)

	; Вывод:
    MOV AH, 02h
OUTPUT_O:
	; Достаем очередное значение из стека.
	; И помещаем в DX.
    POP DX
	; Выводим его в понятном для нас виде. 
    ADD DL, '0'
    INT 21h
	; Повторим ровно столько раз, сколько цифр насчитали. (Для этого увеличивали CX)
    LOOP OUTPUT_O

END_OUTPUT_OCTAL:
	RET
SC1 ENDS

; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	DB 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS

DATA SEGMENT PARA PUBLIC 'DATA'
	number DB 6 DUP ('$') ; Т.к. масимальное число это FFFF.
	array  DW  EXIT, INPUT_NUMBER, OUTPUT_BINARY_NUMBER, OUTPUT_OCTAL_NUMBER 	
DATA ENDS

; Сообщения пользователю.
DataMessage   SEGMENT WORD 'DATA'
Message_menu	DB    10, 13, 5 DUP (' '), 'Menu: ', 10, 13
				DB   '1. Input number.' , 10, 13
				DB   '2. Number output in 2 number system.', 10, 13   
				DB   '3. Number output in 8 number system.', 10, 13  
				DB   '0. EXIT.', 10, 13, 10  
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
	MOV   AX, DataMessage				 
	MOV   DS, AX
	MOV   DX, OFFSET Message_error
	MOV   AH, 9					 
	INT   21h  

main:
assume DS:DataMessage
	; Вывод меню. 
	MOV   AX, DataMessage				 
	MOV   DS, AX					
	MOV   DX, OFFSET Message_menu   
	MOV   AH, 9					 
	INT   21h  

assume DS:DATA
	MOV   AX, DATA
	MOV   DS, AX

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
	MOV AX,  array[SI]	 
	
	CALL AX
	JMP main
SC1 ENDS
END main ; Точка входа в программу.