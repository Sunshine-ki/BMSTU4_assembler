PUBLIC print_a

DATA_PRINT SEGMENT para public 'DATA'
    sumb    DB "A"
            DB '$'
DATA_PRINT ENDS

SC2 SEGMENT para public 'CODE'
    assume  DS:DATA_PRINT
print_a:
    mov ax, DATA_PRINT
    mov ds, ax

    MOV DX, offset sumb
    MOV AH, 09h
print:
    int 21h
    LOOP print

    mov ax, 4c00h
	int 21h
SC2 ENDS
END
    


