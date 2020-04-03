; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	DB 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS


SC1 SEGMENT para public 'CODE'
	; Контролируем правильное обращение к переменным.
	assume CS:SC1

main:
	mov		ax, 255
    xor     cx, cx
    mov     bx, 8 ; основание сс. 10 для десятеричной и т.п.
oi2:
    xor     dx,dx
    div     bx
; Делим число на основание сс. В остатке получается последняя цифра.
; Сразу выводить её нельзя, поэтому сохраним её в стэке.
    push    dx
    inc     cx
; А с частным повторяем то же самое, отделяя от него очередную
; цифру справа, пока не останется ноль, что значит, что дальше
; слева только нули.
    test    ax, ax
    jnz     oi2
; Теперь приступим к выводу.
    mov     ah, 02h
oi3:
    pop     dx

    add     dl, '0'
    int     21h
; Повторим ровно столько раз, сколько цифр насчитали.
    loop    oi3
    

	mov AX, 4c00h
	int 21h

SC1 ENDS
END main ; Точка входа в программу.





; 	MOV CX, 4 
; 	XOR BX, BX
; 	XOR SI, SI

; 	; Выводим \n.
; 	MOV DL, 10
; 	INT 21h
; 	MOV DL, 13
; 	INT 21h

; OUTPUT_O:	
; 	CMP number[SI], '$'  
; 	; Если number[SI] == $ (Спец. символу). то:
; 	JE next1

; 	MOV AH, number[SI]
; 	SHL AH, 1
; 	SHL AH, 1
; 	SHL AH, 1
; 	SHL AH, 1
; 	INC SI
; 	ADD AH, number[SI]

; 	MOV AL, number[SI]
; 	SHL AL, 1
; 	SHL AL, 1
; 	SHL AL, 1
; 	SHL AL, 1
; 	LOOP OUTPUT_O

; next1:
;     xor cx, cx
;     mov bx, 8 ; основание сс. 10 для десятеричной и т.п.
; oi2:
;     xor dx,dx
;     div bx
; ; Делим число на основание сс. В остатке получается последняя цифра.
; ; Сразу выводить её нельзя, поэтому сохраним её в стэке.
;     push dx
;     inc cx
; ; А с частным повторяем то же самое, отделяя от него очередную
; ; цифру справа, пока не останется ноль, что значит, что дальше
; ; слева только нули.
;     test ax, ax
;     jnz oi2
; ; Теперь приступим к выводу.
;     mov ah, 02h
; oi3:
;     pop dx

;     add dl, '0'
;     int 21h
; ; Повторим ровно столько раз, сколько цифр насчитали.
;     loop oi3

; 	RET