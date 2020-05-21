#include <iostream>

using namespace std;

int main()
{
	int sum = 0, a = 2, b = 3;
	__asm(
		"mov %0, %%eax;"
		"mov %1, %%ebx;"
		"add %%eax, %%ebx;"
		: "=r"(sum)
		: "r"(a), "0"(b));
	cout << sum;
}
