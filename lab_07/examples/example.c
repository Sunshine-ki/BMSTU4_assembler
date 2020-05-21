#include <stdio.h>

// Важно помнить, что ассемблерная вставка негативно сказывается на производительности
// программы. Связывание операндов вставки и переменных Си-программы требует
// дополнительных инструкций копирования, но, самое главное, вставки меняют области
// применения оптимизирующих преобразований кода, не позволяя им достичь должных
// результатов.

int main(void)
{
	setbuf(stdout, NULL);

	int a = 1;
	int b = 2;
	int c;

	asm(".intel_syntax noprefix\n\t" // директива GAS, включаем Intel синтаксис.
		"mov eax, %1\n\t"			 // перемещаем в eax значение переменной a.
		"add eax, %2\n\t"			 // прибавляем значение переменной b к eax.
		"mov %0, eax\n\t"			 // перемещаем в переменную c значение eax.
		: "=r"(c)					 // список выходных параметров.
		: "r"(a), "r"(b)			 // список входных параметров.
		: "eax"						 // список разрушаемых регистров.
	);

	printf("%d + %d = %d\n", a, b, c);
}