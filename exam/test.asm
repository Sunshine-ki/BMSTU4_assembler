
StkSeg SEGMENT PARA STACK 'STACK'
 	DB 200h DUP (?)
StkSeg ENDS

DataS SEGMENT WORD 'DATA'

Message DB 13 

DataS ENDS
;
Code SEGMENT WORD 'CODE'
 	ASSUME CS:Code, DS:DataS
DispMsg:
	mov AX,DataS ;загрузка в AX адреса сегмента данных
	mov DS,AX ;установка DS


	mov AH,4Ch
	int 21h 
Code ENDS
 END DispMsg