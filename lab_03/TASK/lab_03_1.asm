;PUBLIC buffer
;EXTERN print_a: far

SSTK SEGMENT para STACK 'STACK'
	db 100 dup(0)
SSTK ENDS

DATA_N SEGMENT para public 'DATA'
    buffer DB 2 ; Т.к. по заданию цифра.
    ;DB '$'
DATA_N ENDS


DATA_PRINT SEGMENT para public 'DATA'
    sumb    DB "A"
            DB '$'
DATA_PRINT ENDS

SC1 SEGMENT para public 'CODE'
	assume CS:SC1, DS:DATA_N
main:
    mov AX, DATA_N
    mov DS, AX

    MOV AH, 0Ah
    MOV DX, offset buffer
    INT 21h	

    SUB buffer + 2, 30h
    mov CL, buffer + 2


print_a:
    MOV DX, offset sumb
    MOV AH, 09h
    int 21h
    LOOP print_a


    ;mov DX, buffer
    ;MOV AH, 09h
    ;int 21h

    mov ax, 4c00h
	int 21h
SC1 ENDS
END main