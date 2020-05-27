// objdump - f a.out (Можем узнать, адрес запуска программы)
// objdump --disassemble a.out (дизассемблирование)
#include <stdio.h>

int factorial(int num)
{
	int res = 1;
	for (int i = 2; i <= num; i++)
		res *= i;
	return res;
}

void horoscope(size_t num)
{
	if (num == 1)
		printf("Do not eat cutlets");
	else if (num == 2)
		printf("Don't go outside");
	else
		printf("My hands");
}

int main(void)
{
	size_t day = 0;

	printf("Enter birthday:");
	// day %= 3;

	scanf("%ld", &day);

	horoscope(day);

	printf("factorial = %d", factorial(5));

	return 0;
}
