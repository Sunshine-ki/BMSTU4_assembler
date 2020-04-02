; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	DB 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS


SC1 SEGMENT para public 'CODE'
	; Контролируем правильное обращение к переменным.
	assume CS:SC1

main:

	mov ax, 10
	mov bx,ax
	mov cx,16
ob1:
	shl bx,1
	jc ob2
	
	mov dl,'0'
	jmp ob3
	
ob2:
	mov dl,'1'
ob3:
	mov ah,2
	int 21h
	loop ob1

	mov AX, 4c00h
	int 21h

SC1 ENDS
END main ; Точка входа в программу.