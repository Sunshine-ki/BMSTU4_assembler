;Описываем идентификатор, 
;как доступный из других модулей.
PUBLIC print_a

; Объявляем сегмент, в котором будет символ "A"
DATA_PRINT SEGMENT para public 'DATA'
    sumb    db "A"
            db '$'
DATA_PRINT ENDS

; Сегмент кода.
SC2 SEGMENT para public 'CODE'
    ; Контролируем правильное обращение к переменным.
    assume  CS:SC2, DS:DATA_PRINT
print_a:
    ; Кладем в DS данные для печати.
    mov AX, DATA_PRINT
    mov DS, ax

    ; 09h - Записать строку в STDOUT.
    ; DS:DX - адрес строки, заканчивающийся символом "$".
    MOV DX, offset sumb
    MOV AH, 09h

    ; Пока что CX != 0 выводить "A".
print:
    int 21h
    LOOP print

    ; Завершение программы.
    mov AX, 4c00h
	int 21h
SC2 ENDS
END
    


