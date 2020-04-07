PUBLIC Message_menu, Message_error, Message_input
PUBLIC number, array

EXTRN EXIT: near
EXTRN INPUT_NUMBER: near
EXTRN OUTPUT_BINARY_NUMBER: near
EXTRN OUTPUT_OCTAL_NUMBER: near


; Сообщения пользователю.
SD1   SEGMENT para public 'DATA'
Message_menu	DB    10, 13, 5 DUP (' '), 'Menu: ', 10, 13
				DB   '1. Input number.' , 10, 13
				DB   '2. Print 2 unsigned.', 10, 13   
				DB   '3. Print 8 signed.', 10, 13  
				DB   '0. Exit.', 10, 13, 10  
				DB	 'Select action: '
				DB   '$'	
Message_error	DB 	  10, 13, 'Input Error!', 10, 13, '$'
Message_input	DB	  10, 13, 'Input number: ', '$'		
SD1   ENDS

DATA SEGMENT PARA PUBLIC 'DATA'
	number DB 6 DUP ('$') ; Т.к. масимальное число это FFFF.
	array  DW  EXIT, INPUT_NUMBER, OUTPUT_BINARY_NUMBER, OUTPUT_OCTAL_NUMBER 	
DATA ENDS

; Объявляем сегмент со смещением, кратному параграфу (16 байт) для стека.
SSTK SEGMENT para STACK 'STACK'
	DB 100 dup(0) ; duplicate (Инициализируем нулями).
SSTK ENDS
end