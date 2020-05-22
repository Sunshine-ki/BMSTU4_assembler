// * Компилить с ключом -masm=intel *
// * for disassemble:
// gdb -q ./a.out
// info functions
// disassemble main
// * for all information:
// disassemble /m main
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define STRING "Hello world"
#define MAX_LEN "1000"
#define ENDL "\n\t"

extern void copy(char *, char *, int);

// Ассемблерные вставки используются для «насильственного»
// размещения в Си-программах ассемблерного
// кода, явно заданного программистом.
size_t my_asm_strlen(char *string)
{
	size_t len = 0; // 64 бита.

	// printf("%ld", sizeof(size_t)); // 8 байт

	// Без ".intel_syntax noprefix\n\t" будет ошибка при компиляции.
	// Директива .intel_syntax меняет синтаксис AT&T на синтаксис Intel; необходимо
	// дополнительно указывать смену синтаксиса для операндов инструкций, noprefix, что позволит
	// писать код в более близком к диалекту nasm виде, не используя при записи имен регистров префикс %.

	// 	В 64-разрядном режиме сегментные регистры CS, DS, ES и SS в формировании линейного (непрерывного)
	// адреса не участвуют, поскольку сегментация в этом режиме не поддерживается.
	// RAX, RCX, RDX, RBX, RSP, RBP, RSI, RDI, R8 — R15 — 64-битные (registry AX)
	// rdi - аналог di, только 64-битный.

	asm(".intel_syntax noprefix\n\t" // директива GAS, включаем Intel синтаксис.
		"lea rdi, [%1]" ENDL		 // команда LEA выполняет вычисление адреса второго операнда и записывание его в первый операнд
		"mov rcx, " MAX_LEN ENDL
		"CLD" ENDL		   // DF = 1.
		"mov al, 0" ENDL   // Терминирующий символ.
		"repne scasb" ENDL // Выполняем повторение.
		"mov rax, " MAX_LEN ENDL
		"sub rax, rcx" ENDL
		"dec rax" ENDL	   // Т.к. посчитает и терминирующий символ.
		"mov %0, rax" ENDL // Записываем в len.
		: "=r"(len)		   // список выходных параметров. (r == register (Т.е. записать в регистр))
		: "r"(string)	   // список входных параметров.
		: "eax");		   // список разрушаемых регистров.

	// Операнды - наши переменные.
	// Каждый описанный операнд затем может использоваться в ассемблерных инструкциях,
	// обращение к нему осуществляется по номеру с префиксом %. Нумерация начинается с 0, и идет
	// непрерывно, объединяя все элементы списков выходных и входных операндов.

	// Для выходных операндов строка ограничения типа должна начинаться с символа `=`.

	// Если требуется что бы операнд был размещен в
	// Каком - либо регистре общего назначения то задаем символом r.
	// Если требуется, что бы операнд был размещен в памяти, вместо
	// символа r следует использовать символ m.

	return len;
}

char *create_string(char *str)
{
	return malloc(sizeof(char) * strlen(str) + 1);
}

int main(int argc, char *argv[])
{
	size_t len = 0;
	char *string_user = create_string(argv[1]);
	char *string_result = create_string(argv[1]);

	strcpy(string_user, argv[1]);

	len = my_asm_strlen(string_user);

	printf("strlen:\nC: %ld\nMy: %ld\n", strlen(string_user), len);

	copy(string_result, string_user, len);

	printf("Copy: %s\n", string_result);

	free(string_user);
	free(string_result);
}