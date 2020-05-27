
a.out:     формат файла elf64-x86-64


Дизассемблирование раздела .init:

00000000000005a8 <_init>:
 5a8:	48 83 ec 08          	sub    rsp,0x8
 5ac:	48 8b 05 35 0a 20 00 	mov    rax,QWORD PTR [rip+0x200a35]        # 200fe8 <__gmon_start__>
 5b3:	48 85 c0             	test   rax,rax
 5b6:	74 02                	je     5ba <_init+0x12>
 5b8:	ff d0                	call   rax
 5ba:	48 83 c4 08          	add    rsp,0x8
 5be:	c3                   	ret    

Дизассемблирование раздела .plt:

00000000000005c0 <.plt>:
 5c0:	ff 35 ea 09 20 00    	push   QWORD PTR [rip+0x2009ea]        # 200fb0 <_GLOBAL_OFFSET_TABLE_+0x8>
 5c6:	ff 25 ec 09 20 00    	jmp    QWORD PTR [rip+0x2009ec]        # 200fb8 <_GLOBAL_OFFSET_TABLE_+0x10>
 5cc:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

00000000000005d0 <__stack_chk_fail@plt>:
 5d0:	ff 25 ea 09 20 00    	jmp    QWORD PTR [rip+0x2009ea]        # 200fc0 <__stack_chk_fail@GLIBC_2.4>
 5d6:	68 00 00 00 00       	push   0x0
 5db:	e9 e0 ff ff ff       	jmp    5c0 <.plt>

00000000000005e0 <printf@plt>:
 5e0:	ff 25 e2 09 20 00    	jmp    QWORD PTR [rip+0x2009e2]        # 200fc8 <printf@GLIBC_2.2.5>
 5e6:	68 01 00 00 00       	push   0x1
 5eb:	e9 d0 ff ff ff       	jmp    5c0 <.plt>

00000000000005f0 <__isoc99_scanf@plt>:
 5f0:	ff 25 da 09 20 00    	jmp    QWORD PTR [rip+0x2009da]        # 200fd0 <__isoc99_scanf@GLIBC_2.7>
 5f6:	68 02 00 00 00       	push   0x2
 5fb:	e9 c0 ff ff ff       	jmp    5c0 <.plt>

Дизассемблирование раздела .plt.got:

0000000000000600 <__cxa_finalize@plt>:
 600:	ff 25 f2 09 20 00    	jmp    QWORD PTR [rip+0x2009f2]        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 606:	66 90                	xchg   ax,ax

Дизассемблирование раздела .text:

0000000000000610 <_start>:
 610:	31 ed                	xor    ebp,ebp
 612:	49 89 d1             	mov    r9,rdx
 615:	5e                   	pop    rsi
 616:	48 89 e2             	mov    rdx,rsp
 619:	48 83 e4 f0          	and    rsp,0xfffffffffffffff0
 61d:	50                   	push   rax
 61e:	54                   	push   rsp
 61f:	4c 8d 05 7a 02 00 00 	lea    r8,[rip+0x27a]        # 8a0 <__libc_csu_fini>
 626:	48 8d 0d 03 02 00 00 	lea    rcx,[rip+0x203]        # 830 <__libc_csu_init>
 62d:	48 8d 3d 6c 01 00 00 	lea    rdi,[rip+0x16c]        # 7a0 <main>
 634:	ff 15 a6 09 20 00    	call   QWORD PTR [rip+0x2009a6]        # 200fe0 <__libc_start_main@GLIBC_2.2.5>
 63a:	f4                   	hlt    
 63b:	0f 1f 44 00 00       	nop    DWORD PTR [rax+rax*1+0x0]

0000000000000640 <deregister_tm_clones>:
 640:	48 8d 3d c9 09 20 00 	lea    rdi,[rip+0x2009c9]        # 201010 <__TMC_END__>
 647:	55                   	push   rbp
 648:	48 8d 05 c1 09 20 00 	lea    rax,[rip+0x2009c1]        # 201010 <__TMC_END__>
 64f:	48 39 f8             	cmp    rax,rdi
 652:	48 89 e5             	mov    rbp,rsp
 655:	74 19                	je     670 <deregister_tm_clones+0x30>
 657:	48 8b 05 7a 09 20 00 	mov    rax,QWORD PTR [rip+0x20097a]        # 200fd8 <_ITM_deregisterTMCloneTable>
 65e:	48 85 c0             	test   rax,rax
 661:	74 0d                	je     670 <deregister_tm_clones+0x30>
 663:	5d                   	pop    rbp
 664:	ff e0                	jmp    rax
 666:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
 66d:	00 00 00 
 670:	5d                   	pop    rbp
 671:	c3                   	ret    
 672:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
 676:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
 67d:	00 00 00 

0000000000000680 <register_tm_clones>:
 680:	48 8d 3d 89 09 20 00 	lea    rdi,[rip+0x200989]        # 201010 <__TMC_END__>
 687:	48 8d 35 82 09 20 00 	lea    rsi,[rip+0x200982]        # 201010 <__TMC_END__>
 68e:	55                   	push   rbp
 68f:	48 29 fe             	sub    rsi,rdi
 692:	48 89 e5             	mov    rbp,rsp
 695:	48 c1 fe 03          	sar    rsi,0x3
 699:	48 89 f0             	mov    rax,rsi
 69c:	48 c1 e8 3f          	shr    rax,0x3f
 6a0:	48 01 c6             	add    rsi,rax
 6a3:	48 d1 fe             	sar    rsi,1
 6a6:	74 18                	je     6c0 <register_tm_clones+0x40>
 6a8:	48 8b 05 41 09 20 00 	mov    rax,QWORD PTR [rip+0x200941]        # 200ff0 <_ITM_registerTMCloneTable>
 6af:	48 85 c0             	test   rax,rax
 6b2:	74 0c                	je     6c0 <register_tm_clones+0x40>
 6b4:	5d                   	pop    rbp
 6b5:	ff e0                	jmp    rax
 6b7:	66 0f 1f 84 00 00 00 	nop    WORD PTR [rax+rax*1+0x0]
 6be:	00 00 
 6c0:	5d                   	pop    rbp
 6c1:	c3                   	ret    
 6c2:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]
 6c6:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
 6cd:	00 00 00 

00000000000006d0 <__do_global_dtors_aux>:
 6d0:	80 3d 39 09 20 00 00 	cmp    BYTE PTR [rip+0x200939],0x0        # 201010 <__TMC_END__>
 6d7:	75 2f                	jne    708 <__do_global_dtors_aux+0x38>
 6d9:	48 83 3d 17 09 20 00 	cmp    QWORD PTR [rip+0x200917],0x0        # 200ff8 <__cxa_finalize@GLIBC_2.2.5>
 6e0:	00 
 6e1:	55                   	push   rbp
 6e2:	48 89 e5             	mov    rbp,rsp
 6e5:	74 0c                	je     6f3 <__do_global_dtors_aux+0x23>
 6e7:	48 8b 3d 1a 09 20 00 	mov    rdi,QWORD PTR [rip+0x20091a]        # 201008 <__dso_handle>
 6ee:	e8 0d ff ff ff       	call   600 <__cxa_finalize@plt>
 6f3:	e8 48 ff ff ff       	call   640 <deregister_tm_clones>
 6f8:	c6 05 11 09 20 00 01 	mov    BYTE PTR [rip+0x200911],0x1        # 201010 <__TMC_END__>
 6ff:	5d                   	pop    rbp
 700:	c3                   	ret    
 701:	0f 1f 80 00 00 00 00 	nop    DWORD PTR [rax+0x0]
 708:	f3 c3                	repz ret 
 70a:	66 0f 1f 44 00 00    	nop    WORD PTR [rax+rax*1+0x0]

0000000000000710 <frame_dummy>:
 710:	55                   	push   rbp
 711:	48 89 e5             	mov    rbp,rsp
 714:	5d                   	pop    rbp
 715:	e9 66 ff ff ff       	jmp    680 <register_tm_clones>

000000000000071a <factorial>:
 71a:	55                   	push   rbp
 71b:	48 89 e5             	mov    rbp,rsp
 71e:	89 7d ec             	mov    DWORD PTR [rbp-0x14],edi ; Аргумент arg
  								; Локальная переменная, содержащая единицу. (a)
 721:	c7 45 f8 01 00 00 00 	mov    DWORD PTR [rbp-0x8],0x1
  								; Локальная переменная, содержащая 2. (b)
 728:	c7 45 fc 02 00 00 00 	mov    DWORD PTR [rbp-0x4],0x2
 72f:	eb 0e                	jmp    73f <factorial+0x25>
								; eax = (a)
 731:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8]
								; Знаковое умножение  (a) eax *= (b)
 734:	0f af 45 fc          	imul   eax,DWORD PTR [rbp-0x4]
 								; (a) = eax (Т.е. a *= b) 
 738:	89 45 f8             	mov    DWORD PTR [rbp-0x8],eax
 								; b++
 73b:	83 45 fc 01          	add    DWORD PTR [rbp-0x4],0x1
  								; eax = b
 73f:	8b 45 fc             	mov    eax,DWORD PTR [rbp-0x4]
  								; Сравниваем eax (b) и arg
 742:	3b 45 ec             	cmp    eax,DWORD PTR [rbp-0x14]
  								; Eсли меньше или равно, то переходим 731 (Цикл, пока b <= arg (b++))
 745:	7e ea                	jle    731 <factorial+0x17>
 747:	8b 45 f8             	mov    eax,DWORD PTR [rbp-0x8] ; Возвращаем (a)
 74a:	5d                   	pop    rbp
 74b:	c3                   	ret    

000000000000074c <horoscope>:
 74c:	55                   	push   rbp
 74d:	48 89 e5             	mov    rbp,rsp ; При запуске программы rsp указывает на вершину стека.
 750:	48 83 ec 10          	sub    rsp,0x10
 								; В rdi лежит переданный аргумент. Значит в подпрограмму передают 1 аргумент (рзарядность 64)
								; rbp - указывает на вершину стека (см. комманду  74d)
								; Значит помщаем арумент в стек [rbp-0x8] == arg. 
 754:	48 89 7d f8          	mov    QWORD PTR [rbp-0x8],rdi  
								; Сравниваем arg (переданный аргумент) с единицой
 758:	48 83 7d f8 01       	cmp    QWORD PTR [rbp-0x8],0x1
 								; Если не ноль, то переходим на команду 772.
 75d:	75 13                	jne    772 <horoscope+0x26>
  								; Иначе выводим сообшение.(printf)
 75f:	48 8d 3d 4e 01 00 00 	lea    rdi,[rip+0x14e]        # 8b4 <_IO_stdin_used+0x4>
 766:	b8 00 00 00 00       	mov    eax,0x0
 76b:	e8 70 fe ff ff       	call   5e0 <printf@plt>
   								; Переходим на 79d (Как мы увидим дальше, это выход)
 770:	eb 2b                	jmp    79d <horoscope+0x51>
   								; Сравниваем arg с 2
 772:	48 83 7d f8 02       	cmp    QWORD PTR [rbp-0x8],0x2
  								; Если не равно, то переходим на 78c
 777:	75 13                	jne    78c <horoscope+0x40>
   								; Иначе выводим сообщение (printf)
 779:	48 8d 3d 47 01 00 00 	lea    rdi,[rip+0x147]        # 8c7 <_IO_stdin_used+0x17>
 780:	b8 00 00 00 00       	mov    eax,0x0
 785:	e8 56 fe ff ff       	call   5e0 <printf@plt>
   								; Переходим на 79d (выход)
 78a:	eb 11                	jmp    79d <horoscope+0x51>
    							; Вывод сообщения.
 78c:	48 8d 3d 45 01 00 00 	lea    rdi,[rip+0x145]        # 8d8 <_IO_stdin_used+0x28>
 793:	b8 00 00 00 00       	mov    eax,0x0
 798:	e8 43 fe ff ff       	call   5e0 <printf@plt>
   								; Ничего не делает, т.е. ничего не возвращает
 79d:	90                   	nop
 79e:	c9                   	leave ;  Скопировать EBP на ESP и затем восстановить старый EBP из стека.
 79f:	c3                   	ret    

00000000000007a0 <main>:
 7a0:	55                   	push   rbp
 7a1:	48 89 e5             	mov    rbp,rsp
 7a4:	48 83 ec 10          	sub    rsp,0x10
 7a8:	64 48 8b 04 25 28 00 	mov    rax,QWORD PTR fs:0x28
 7af:	00 00 
 7b1:	48 89 45 f8          	mov    QWORD PTR [rbp-0x8],rax
 7b5:	31 c0                	xor    eax,eax
 7b7:	48 c7 45 f0 00 00 00 	mov    QWORD PTR [rbp-0x10],0x0
 7be:	00 
 7bf:	48 8d 3d 1b 01 00 00 	lea    rdi,[rip+0x11b]        # 8e1 <_IO_stdin_used+0x31>
 7c6:	b8 00 00 00 00       	mov    eax,0x0
 7cb:	e8 10 fe ff ff       	call   5e0 <printf@plt>
 7d0:	48 8d 45 f0          	lea    rax,[rbp-0x10]
 7d4:	48 89 c6             	mov    rsi,rax
 7d7:	48 8d 3d 13 01 00 00 	lea    rdi,[rip+0x113]        # 8f1 <_IO_stdin_used+0x41>
 7de:	b8 00 00 00 00       	mov    eax,0x0
 7e3:	e8 08 fe ff ff       	call   5f0 <__isoc99_scanf@plt>
 7e8:	48 8b 45 f0          	mov    rax,QWORD PTR [rbp-0x10]
 7ec:	48 89 c7             	mov    rdi,rax
 7ef:	e8 58 ff ff ff       	call   74c <horoscope>
 7f4:	bf 05 00 00 00       	mov    edi,0x5
 7f9:	e8 1c ff ff ff       	call   71a <factorial>
 7fe:	89 c6                	mov    esi,eax
 800:	48 8d 3d ee 00 00 00 	lea    rdi,[rip+0xee]        # 8f5 <_IO_stdin_used+0x45>
 807:	b8 00 00 00 00       	mov    eax,0x0
 80c:	e8 cf fd ff ff       	call   5e0 <printf@plt>
 811:	b8 00 00 00 00       	mov    eax,0x0
 816:	48 8b 55 f8          	mov    rdx,QWORD PTR [rbp-0x8]
 81a:	64 48 33 14 25 28 00 	xor    rdx,QWORD PTR fs:0x28
 821:	00 00 
 823:	74 05                	je     82a <main+0x8a>
 825:	e8 a6 fd ff ff       	call   5d0 <__stack_chk_fail@plt>
 82a:	c9                   	leave  
 82b:	c3                   	ret    
 82c:	0f 1f 40 00          	nop    DWORD PTR [rax+0x0]

0000000000000830 <__libc_csu_init>:
 830:	41 57                	push   r15
 832:	41 56                	push   r14
 834:	49 89 d7             	mov    r15,rdx
 837:	41 55                	push   r13
 839:	41 54                	push   r12
 83b:	4c 8d 25 66 05 20 00 	lea    r12,[rip+0x200566]        # 200da8 <__frame_dummy_init_array_entry>
 842:	55                   	push   rbp
 843:	48 8d 2d 66 05 20 00 	lea    rbp,[rip+0x200566]        # 200db0 <__init_array_end>
 84a:	53                   	push   rbx
 84b:	41 89 fd             	mov    r13d,edi
 84e:	49 89 f6             	mov    r14,rsi
 851:	4c 29 e5             	sub    rbp,r12
 854:	48 83 ec 08          	sub    rsp,0x8
 858:	48 c1 fd 03          	sar    rbp,0x3
 85c:	e8 47 fd ff ff       	call   5a8 <_init>
 861:	48 85 ed             	test   rbp,rbp
 864:	74 20                	je     886 <__libc_csu_init+0x56>
 866:	31 db                	xor    ebx,ebx
 868:	0f 1f 84 00 00 00 00 	nop    DWORD PTR [rax+rax*1+0x0]
 86f:	00 
 870:	4c 89 fa             	mov    rdx,r15
 873:	4c 89 f6             	mov    rsi,r14
 876:	44 89 ef             	mov    edi,r13d
 879:	41 ff 14 dc          	call   QWORD PTR [r12+rbx*8]
 87d:	48 83 c3 01          	add    rbx,0x1
 881:	48 39 dd             	cmp    rbp,rbx
 884:	75 ea                	jne    870 <__libc_csu_init+0x40>
 886:	48 83 c4 08          	add    rsp,0x8
 88a:	5b                   	pop    rbx
 88b:	5d                   	pop    rbp
 88c:	41 5c                	pop    r12
 88e:	41 5d                	pop    r13
 890:	41 5e                	pop    r14
 892:	41 5f                	pop    r15
 894:	c3                   	ret    
 895:	90                   	nop
 896:	66 2e 0f 1f 84 00 00 	nop    WORD PTR cs:[rax+rax*1+0x0]
 89d:	00 00 00 

00000000000008a0 <__libc_csu_fini>:
 8a0:	f3 c3                	repz ret 

Дизассемблирование раздела .fini:

00000000000008a4 <_fini>:
 8a4:	48 83 ec 08          	sub    rsp,0x8
 8a8:	48 83 c4 08          	add    rsp,0x8
 8ac:	c3                   	ret  