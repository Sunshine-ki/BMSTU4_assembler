PUBLIC INPUT_NUMBER

EXTRN Message_input: byte
EXTRN number: byte

SC1 SEGMENT para public 'CODE'
	assume CS:SC1
; Ввод числа в 16 с.с.
INPUT_NUMBER proc near ; Процедура (Описание).
; Выводим сообщение о просьбе ввести число.
	MOV AX, seg Message_input
	MOV DS, AX

	MOV DX, OFFSET DS:Message_input
	MOV AH, 9					 
	INT 21h  

	MOV AX, seg number
	MOV ES, AX

	; Т.к. пользователь может ввести только 
	; FFFF и Enter. 
	MOV CX, 5 
	; Зануляем BX.
	XOR BX, BX 
	INPUT:
	; Записываем специальный символ в следующее
	; Значение, чтобы знать, где конец числа. 
	MOV ES:number[BX + 1], '$'
	; Считываем символ в AL.
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
	MOV ES:number[BX], AL 
	; BX на каждом шаге увеличиваем на единицу. 
	INC BX
	LOOP INPUT
END_INPUT:
	RET
INPUT_NUMBER endp ; Конец процедуры.
SC1 ENDS
END