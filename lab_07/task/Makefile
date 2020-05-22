# For disassemble:
#FLAGS := -S
FLAGS := -Wall -g -masm=intel 

app.out: main.c str_copy.asm
	nasm -f elf64 str_copy.asm -o str_copy.o 
	gcc $(FLAGS) -c main.c -o main.o
	gcc -o app.out main.o str_copy.o
	rm *.o

run:
	./app.out  "Hello world"

gdb:
	gdb -q ./app.out

memory:
	valgrind ./app.out "1234"

clean:
	rm -f *.o *.exe *.out   