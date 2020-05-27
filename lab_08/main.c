// MMX(Multimedia Extensions — мультимедийные расширения) —
// коммерческое название дополнительного SIMD - набора инструкций,
// разработанного компанией Intel и впервые представленного в 1997 году
// одновременно с линией процессоров Pentium MMX.Набор инструкций
// был предназначен для ускорения процессов кодирования / декодирования
// потоковых аудио - и видеоданных.
// Увеличение эффективности обработки больших потоков данных(изображения, звук,
// видео...) - выполнение простых операций над массивами однотипных чисел.
// 8 64-битных регистров MM0..MM7 - мантиссы регистров FPU. При записи в MMn
// экспонента и знаковый бит заполняются единицами

#include <stdio.h>
// Сопроцессор (FPU – Floating Point Unit) (Работа с вещественными числами.)

#define ENDL "\n\t"
#define OK 0

// Все названия команд начинаются с f(float).
// Регистры FPU:
// R0..R7, адресуются не по именам, а рассматриваются в качестве стека ST. ST
// соответствует регистру - текущей вершине стека, ST(1)..ST(7) - прочие регистры
// SR - регистр состояний, содержит слово состояния FPU. Сигнализирует о
// различных ошибках, переполнениях (При fld номер вершины в SR увеличивается)
// Регистры данных – 8 основных регистров r0, r1, ..., r7(физические номера).
// Эти регистры рассматриваются как стек(кольцо).Вершина стека – st(0),
// а более глубокие элементы – st(1), st(2), ..., st(7)(логические номера).
float add(float a, float b)
{
	float result = 0;

	asm(".intel_syntax noprefix" ENDL // директива GAS, включаем Intel синтаксис.
		"fld %1" ENDL				  // Загрузить вещественное число из источника в стек. st(0) == a
		"fadd %2" ENDL				  // Добавить к вершине стека b.  st(0) += b
		"fstp %0" ENDL				  // FSTP - считать число с вершины стека в приёмник. result = st(0)
		: "=m"(result)				  // список выходных параметров. (m == memory (Т.е. разместить в памяти))
		: "m"(a), "m"(b)			  // список входных параметров.
		:);

	return result;
}

float sub(float a, float b)
{
	float result = 0;

	asm(".intel_syntax noprefix" ENDL
		"fld %1" ENDL
		"fsub %2" ENDL
		"fstp %0" ENDL
		: "=m"(result)
		: "m"(a), "m"(b)
		:);

	return result;
}

float mul(float a, float b)
{
	float result = 0;

	asm(".intel_syntax noprefix" ENDL
		"fld %1" ENDL
		"fmul %2" ENDL
		"fstp %0" ENDL
		: "=m"(result)
		: "m"(a), "m"(b)
		:);

	return result;
}
// Особые числа FPU
// Положительная бесконечность : знаковый - 0, мантисса - нули, экспонента - единицы
// Отрицательная бесконечность : знаковый - 1, мантисса - нули, экспонента - единицы
// NaN(Not a Number)
// Денормализованные числа(экспонента = 0) : находятся ближе к нулю, чем наименьшее представимое нормальное число
float div(float a, float b)
{
	float result = 0;

	asm(".intel_syntax noprefix" ENDL
		"fld %1" ENDL
		"fdiv %2" ENDL
		"fstp %0" ENDL
		: "=m"(result)
		: "m"(a), "m"(b)
		:);

	return result;
}

int main()
{
	float a, b, result; // (sizeof(float));  4 -> 32)
	int operation = 1;

	printf("\toperation:\n\n\t1 - add\n\t2 - sub \n\t3 - mul\n\t4 - div\n\t0 - exit\n\n");
	while (1)
	{
		printf("operation: ");
		scanf("%d", &operation);
		if (!operation)
			break;

		printf("Input a: ");
		scanf("%f", &a);
		printf("Input b: ");
		scanf("%f", &b);

		switch (operation)
		{
		case 1:
			result = add(a, b);
			break;
		case 2:
			result = sub(a, b);
			break;
		case 3:
			result = mul(a, b);
			break;
		case 4:
			result = div(a, b);
			break;

		default:
			break;
		}

		printf("result = %f	\n", result);
	}

	return OK;
}

// Корень.
// #include <stdio.h>

// #define ENDL "\n\t"

// // Все названия команд начинаются с f(float).

// float my_sqrt(float a)
// {
// 	float result = 0;

// 	asm(".intel_syntax noprefix" ENDL // директива GAS, включаем Intel синтаксис.
// 		"fld %1" ENDL				  // загрузить вещественное число из источника в стек.
// 		"fsqrt" ENDL				  // Взять корень.
// 		"fstp %0" ENDL				  // FST/FSTP - скопировать/считать число с вершины стека в приёмик
// 		: "=m"(result)				  // список выходных параметров. (m == memory (Т.е. разместить в памяти))
// 		: "m"(a)					  // список входных параметров.
// 		:);

// 	return result;
// }

// int main()
// {

// 	// "fld %1" ENDL  // загрузить вещественное число из источника в стек.
// 	// "fmul %0" ENDL // Вычесть из вершины стека result
// 	// "fstp %0" ENDL // FST/FSTP - скопировать/считать число с вершины стека в приёмник
// 	float num;
// 	scanf("%f", &num);

// 	float result = my_sqrt(num);

// 	printf("result = %f	\n", result);

// 	return 0;
// }
// define + asm.
// #define CODE_ASM(command) ".intel_syntax noprefix" ENDL \
// 						  "fld %1" ENDL                 \
// 							  command ENDL              \
// 						  "fstp %0" ENDL

// float func(float a, float b, int command)
// {
// 	float result = 0;

// 	switch (command)
// 	{
// 	case 1:
// 		asm(CODE_ASM("fadd  %2")
// 			: "=m"(result)	 // список выходных параметров. (m == memory (Т.е. разместить в памяти))
// 			: "m"(a), "m"(b) // список входных параметров.
// 			:);
// 		break;
// 	case 2:
// 		asm(CODE_ASM("fsub  %2")
// 			: "=m"(result)
// 			: "m"(a), "m"(b)
// 			:);
// 		break;
// 	case 3:
// 		asm(CODE_ASM("fmul  %2")
// 			: "=m"(result)
// 			: "m"(a), "m"(b)
// 			:);
// 		break;
// 	case 4:
// 		asm(CODE_ASM("fdiv  %2")
// 			: "=m"(result)
// 			: "m"(a), "m"(b)
// 			:);
// 		break;

// 	default:
// 		break;
// 	}

// 	return result;
// }

// MOVD - пересылка двойных слов (4 байта). (sizeof(float)); // 4 -> 32)
// asm(".intel_syntax noprefix" ENDL // директива GAS, включаем Intel синтаксис.
// 	"xor ecx, ecx" ENDL
// 	"mov cx, 2" ENDL
// 	"fld1" ENDL // FLD1 – 1,0 константа. Лежит в стеке. st(0) = 1
// 	"fld1" ENDL // FLD1 – 1,0 константа. Лежит в стеке. st(1) = 1
// 	"fld1" ENDL // FLD1 – 1,0 константа. Лежит в стеке. st(2) = 1
// 	"a1:" ENDL
// 	"faddp st(2), st(0)" ENDL // st(2) += st(0) (st(0) == 1)
// 	"fmul st(0), st(1)" ENDL  //  st(0) *= st(1)
// 	"fld1" ENDL				  // FLD1 – 1,0 константа. Лежит в стеке. st(2) = 1
// 	"loop a1" ENDL
// 	"fstp %0" ENDL // Вершина стека – st(0)
// 	: "=m"(result) // список выходных параметров. (m == memory (Т.е. разместить в памяти))
// 	: "m"(n)	   // список входных параметров.
// 	:);
//
// float a = 25, b = 0;
// // MOVD - пересылка двойных слов (4 байта).
// asm(".intel_syntax noprefix" ENDL // директива GAS, включаем Intel синтаксис.
// 	"fld %1" ENDL				  // загрузить вещественное число из источника в стек.
// 	"fsqrt" ENDL				  // Взять корень.
// 	"fstp %0" ENDL				  // FST/FSTP - скопировать/считать число с вершины стека в приёмик
// 	: "=m"(b)					  // список выходных параметров. (m == memory (Т.е. разместить в памяти))
// 	: "m"(a)					  // список входных параметров.
// 	:);

// printf("result = a = %f b = %f\n", a, b);
