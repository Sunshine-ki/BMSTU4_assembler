FLAGS := -g -masm=intel

app.out: string.c
	gcc -o app.out $^ $(FLAGS)

run:
	./app.out  "Hello world"

gdb:
	gdb -q ./app.out

memory:
	valgrind ./app.out "1234"

clean:
	rm -f *.o *.exe *.out   