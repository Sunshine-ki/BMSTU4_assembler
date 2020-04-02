; Резервируем память и заполняем ее 3444,
; А во втором файле просто делаем метки на эти данные.
; Выводит D4.
STK SEGMENT para STACK 'STACK'
	db 100 dup(0)
STK ENDS

SD1 SEGMENT para common 'DATA'
	W dw 3444h ;34 - 4, 44 - D
SD1 ENDS
END
