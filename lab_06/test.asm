.model tiny

code    segment; определение кодового сегмента
        assume  cs:code,ds:code  ; CS и DS указывают на сегмент кода
        org     100h    ; размер PSP для COM программы
start:  jmp     load    ; переход на нерезидентную часть
        old     dd  0   ; адрес старого обработчика 
        buf     db  ' 00:00:00 ',0       ; шаблон для вывода текущего времени

decode  proc   ; процедура заполнения шаблона
        mov     ah,  al ; преобразование двоично-десятичного 
        and     al,  15 ; числа в регистре AL
        shr     ah,  1
        shr     ah,  1  ; в пару ASCII символов
        shr     ah,  1  ; в пару ASCII символов
        shr     ah,  1  ; в пару ASCII символов
		  ; в пару ASCII символов
        add     al,  '0'
        add     ah,  '0'
        mov     buf[bx + 1],  ah ; запись ASCII символов
        mov     buf[bx + 2],  al ; в шаблон
        add     bx,  3      
        ret    ; возврат из процедуры
decode  endp   ; конец процедуры 

clock   proc
        pushf 
        call    cs:old 
        push    ds   
        push    es
		push    ax
		push    bx
        push    cx
        push    dx
		push    di
        push    cs
        pop     ds

        mov     ah,  2 
        int     1Ah     

        xor     bx,  bx ; настройка BX на начало шаблона
        mov     al,  ch ; в AL - часы
        call    decode  ; вызов процедуры заполнения шаблона - часы
        mov     al,  cl ; в AL - минуты
        call    decode  ; вызов процедуры заполнения шаблона - минуты
        mov     al,  dh ; в AL - секунды
        call    decode  ; вызов процедуры заполнения шаблона - секунды 

        mov     ax,  0B800h      ; настройка AX на сегмент видеопамяти
        mov     es,  ax ; запись в ES значения сегмента видеопамяти
        xor     di,  di ; настройка DI на начало сегмента видеопамяти
        xor     bx,  bx ; настройка BX на начало шаблона
        mov     ah,  1Bh; атрибут выводимых символов
@@1:    mov     al,  buf[bx]     ; цикл для записи символов шаблона в видеопамять
        stosw  ; запись очередного символа и атрибута
        inc     bx      ; инкремент указателя на символ шаблона
        cmp     buf[bx],  0      ; пока не конец шаблона,
        jnz     @@1     ; продолжать запись символов

@@5:    pop     di      
        pop     dx
        pop     cx
        pop     bx
        pop     ax
        pop     es
        pop     ds
        iret   
clock   endp   
load:   mov     ax,  351ch       
        int     21h     

		mov     word ptr old,  bx
        mov     word ptr old + 2,  es   
        mov     ax,  251ch      
        mov     dx,  offset clock
        int     21h    
		MOV DX, OFFSET load
    	INT 27h
code    ends   ; конец кодового сегмента
        end     start   ; конец программы

; .186
; .model tiny

; .model small
; .stack 100h
; .code

; start:                
;         jmp             initialize
; int09h_handler proc  far  ; начало обработчика INT 09h    
;         pushf        
;         call        dword ptr cs:old_int09h
;         jmp            work
; param                label byte
;     msg                db    "OK", '$'    
;     old_int09h        dd 0
; ;=================================
; ; Обработчик прерывания 09h (IRQ1)             
; work:
;         pusha        
;         push        cs
;         pop            ds
;         xor            ax, ax
;         mov            ah,9
;         mov            dx,offset msg ; вывод "Ok"
;         int            21h                    
;         popa
;         iret
; int09h_handler  endp
; ;====================================
; ;    end of the resident code
; ;    beginning of the initialization procedure
; ;====================================
; initialize:
;         push        cs
;         pop            ds        
        
;         mov     ax,  3509h  ; получение адреса старого обработчика
;         int     21h; прерываний от клавиатуры
;         mov     word ptr old_int09h,  bx; сохранение смещения обработчика
;         mov     word ptr old_int09h + 2,  es    ; сохранение сегмента обработчика
;         mov     ax,  2509h       ; установка адреса нашего обработчика
;         mov     dx,  offset int09h_handler; указание смещения нашего обработчика
;         int     21h     ; вызов DOS                
        
;         mov            dx,offset initialize     ; DX - адрес первого байта за
;          ; концом резидентной части
;         int            27h     ; завершить выполнение, оставшись
;          ; резидентом
; end start