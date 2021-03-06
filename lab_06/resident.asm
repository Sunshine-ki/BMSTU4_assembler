; Модель tiny работает только в 16-разрядных приложениях MS-DOS.
; В этой модели все данные и код располагаются в одном сегменте. 
.model tiny

; Определяем сегмент с кодом.
code    segment
; Контролируем правильное обращение к регистрам.
; CS и DS указывают на сегмент кода.
    assume cs:code,ds:code     
    ; Префикс программного сегмента (PSP - Program Segment Prefix).  
    ; В COM-программах начальное смещение при запуске 100h,
    org 100h ; размер PSP для COM программы.
start:
    ; Сначала в памяти располагаются данные и
    ; подпрограмма обрабо   тчика прерывания,
    ; затем секция инициализации (которая имеет
    ; точку входа INIT и именно в эту точку
    ; передается управление при запуске программы)
    jmp init
    ; Данные и процедура обработчика прерывания.
    old_1c dd 0     ; Адрес старого обработчика.
    color byte 11   ; Голубой цвет.

handler proc        ; Процедура обработчика прерываний от таймера
    pushf           ; создание в стеке структуры для IRET
    call cs:old_1c  ; вызов старого обработчика прерываний
    ; После вызова нашего обработчика 
    ; Все регистры должны остаться 
    ; Прежними, поэтому мы сохраняем их в стек,
    ; А в конце процесса достаем их.
    push ds
    push es
    push ax
    push bx
    push cx
    push dx
    ; При вызове команды INT XX:
    ; В сегментный регистр CS по вычисленному смещению из таблицы векторов 
    ; прерываний заносится значение сегмента обработчика прерывания
    ; Поэтому мы помещаем его в ds.
    push cs
    pop  ds
    ; INT 1aH: ввод-вывод для времени.
    ; AH = 02H читать время. (функция для получения текущего времени).
    ; выход: CH = часы, CL = минуты, DH = секунды
    ; (пример: CX = 1243H = 12:43)
    mov ah, 2 
    int 1Ah  

    ; Загружаем адрес видеопамяти текстового режима. 
	mov ax, 0b800h
	mov es, ax
    
	mov ah, color 
    ; rol ah, 1
    mov bh, 15      ; 1111
    and bh, ah      ; Получаем цвет текста.
    cmp bh, 15      ; Сравниваем с 1111 (максимальный код цвета текста).
    jne increment   ; Если не равен, то прибавляем единицу.
    ; reset
    ; Если равен, то сбрасываем (делам 0000)
    and ah, 240     ; 1111 0000 
    jmp save_color

increment:
    add ah, 1

save_color:
    mov color, ah

	; Вывод секунд
	MOV CL, 8
	SHR DX, CL      ; Было СС00 Станет 00С1С2 (Где С1С2 - секунды). (1200 -> 0012)
	mov al, 15      ; 1111
	and al, dl      ;В al Запишется С2 (al = 02)
	add al, '0'     ; Превратим ее в читаемый вид и запишем по адресу видопамяти 
                    ; (+ смещение(для того, чтобы выводилось наверху справа)).  (al = 32)
	mov es:[008Eh], ax
	mov al, 240     ; 1111 0000 
	and al, dl      ; В al Запишется С1 (al = 10) 
	MOV CL, 4       ; Сдвинем вправо, потому что al 
                    ; содержит 00С0, а нам нужно 000С
	SHR AL, CL      ; (al = 01)
	add al, '0'     ; Превратим ее в читаемый вид (al = 31)
	mov es:[008Eh] - 2, ax ; Запишем правее.

    ; Восстанавливаем регистры.
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop ds

    ; iret - Происходит передача 
    ; управления в прерванную программу, 
    ; на команду, находящуюся непосредственно 
    ; за командой программного прерывания INT XX.
    ; Из стека восстанавливается значение регистра IP.
    ; Из стека восстанавливается значение регистра CS.
    ; Из стека восстанавливается значение регистра флагов.
    iret
handler endp ; конец процедуры обработчика

init:
    ; Секция инициализации. 
    ; Отвечает за устаноку резидента в памяти,
    ; А также заменяет вектор прерывания на свой адрес.
    ; Она расположенна в самом конце, т.к.
    ; Нам не нужно ее сохранять
    ; Она выполняет свои действия один раз
    ; После чего ее можно удалить из памяти 
    
    ; Для начала нам нужно получить 
    ; адрес старого обработчика прерывания (от таймера)
    ; И сохранить его в памяти (резидетной программы). 
    ; В AH записывается номер функции (35h - дать вектор прерывания)
    ; В AL = номер прерывания (00H до 0ffH).
    ; В нашем случае номер прерывания 1С
    ; 1С - пользовательское прерывание по таймеру
    ; Этот вектор берет по каждому
    ; тику аппаратных часов (каждые 55 миллисекунд;
    ; приблизительно 18.2 раз в секунду). 
    ; Первоначально он указывает на IRET,
    ; Но может быть изменен пользовательской программой,
    ; Чтобы адресовать фоновую программу пользователя, 
    ; базирующуюся на таймере.
    ; 1cH выполняется во время аппаратного прерывания.
    mov ax, 351Ch ; 
    int 21h
    ; В bx - смещения обработчика.
    ; В es - сегмента обработчика.

    ; Операция WORD PTR
    ; указывает Турбо Ассемблеру, что данный 
    ; операнд в памяти нужно ин-
    ; терпретировать, как операнд размером в слово
    ; Эти операции служат для временного выбора 
    ; размера данных, которые мы хотим считать из памяти.

    mov word ptr old_1c, bx ; Сохраняем смещение обработчика.
    mov word ptr old_1c + 2,  es ; Сохраняем сегмент обработчика.

    ; 25H: установить вектор прерывания
    ; AH = 25H
    ; AL = номер прерывания
    ; DS:DX = вектор прерывания: адрес программы обработки прерывания
    ; ds - и так указывает на нужный нам сегмент (Благодаря assume)
    ; В ds помещаем смещение нашего обработчика (handler). 
 
    mov ax, 251Ch
    mov dx, offset handler
    int 21h


    ; Теперь нам нужно 
    
    ; int 27h - для com-программ.
    ; В DX требуется загрузить смещение команды, 
    ; начиная с которой фрагмент
    ; Программы может быть удалён из памяти.
    ; Т.е. адрес за резидентным участком программы.
    mov dx, offset init
    int 27h 
code ends ; Конец кодового сегмента.
end start