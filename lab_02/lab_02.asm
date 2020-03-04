StkSeg SEGMENT PARA STACK 'STACK'
	DB 200h DUP (?)
StkSeg ENDS
;

DataS SEGMENT WORD 'DATA'
HelloMessage 	DB 13
				DB 10
				DB 'Hello, world !'
				DB '$'
DataS ENDS
;
Code SEGMENT WORD 'CODE'
	ASSUME CS:Code, DS:DataS
DispMsg:
	mov AX,DataS
	mov DS,AX
	mov DX,OFFSET HelloMessage
	mov AH,9

	mov CX, 3	
print_hello:
	int 21h
	LOOP print_hello

	mov AH,7
	INT 21h
	mov AH,4Ch
	int 21h 
Code ENDS
	END DispMsg