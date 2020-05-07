StkSeg  SEGMENT PARA STACK 'STACK'
        DB      200h DUP (?)
StkSeg  ENDS

DS2 SEGMENT AT 0b800h
	CA LABEL byte
	ORG 80 * 2 - 10 * 2 ; чч.мм.сс
	symb LABEL word
DS2 ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, es:DS2
main:
	; 02H ¦AT¦ читать время из "постоянных" (CMOS) часов реального времени
	;     выход: CH = часы в коде BCD   (пример: CX = 1243H = 12:43)
	;            CL = минуты в коде BCD
	;            DH = секунды в коде BCD
	;     выход: CF = 1, если часы не работают
	mov ax, DS2
	mov es, ax

	color byte 11 ; Голубой.

s:
	mov ax, 0b800h
	mov es, ax

	; Время.
    mov ah, 02h
    int 1Ah
	
	mov ah, color ; Голубой цвет.


    mov color, ah
    mov bh, 15      ; 1111
    and bh, ah      ; Получаем цвет текста.
    cmp bh, 15      ; Сравниваем с 1111 (максимальный код цвета текста).
    jne increment   ; Если не равен, то прибавляем единицу.
    ; reset
    ; Если равен, то сбрасываем (делам 0000)
    and ah, 240     ; 1111 0000 



increment:
    add ah, 1


	; Вывод секунд
	MOV CL, 8
	SHR DX, CL
	mov al, 15 ; 1111
	and al, dl
	add al, '0'
	mov es:[008Eh], ax
	mov al, 240 ; 1111 0000
	and al, dl
	MOV CL, 4
	SHR AL, CL
	add al, '0'
	mov es:[008Eh] - 2, ax

JMP s


	; Делает прерываение для выхода.
	MOV AX, 4c00h
	INT 21h
SC1 ENDS
END main ; Точка входа в программу.