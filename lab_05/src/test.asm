; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	DB 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS


SC1 SEGMENT para public 'CODE'
	; Контролируем правильное обращение к переменным.
	assume CS:SC1

main:

    MOV CL, 2
    SHL BH, CL

	mov AX, 4c00h
	int 21h

SC1 ENDS
END main ; Точка входа в программу.