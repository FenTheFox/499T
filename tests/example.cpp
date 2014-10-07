/*
* compile with:
* 	clang++ example.cpp -I./source
*/

#include <iostream>
#include <fstream>
#include <stdlib.h>

#include "hwtime.h"
#include "replacemalloc.h"

using namespace std;

extern "C" void *xxmalloc(size_t size) __attribute__((weak_import));

void test_1()
{
	ofstream *file = new ofstream("./example.txt");
	if(!file)
	{
		cerr << "Cannot open the output file." << endl;
		return;
	}
	file->close();
	
	replace_malloc(10);
	replace_malloc(100);
	replace_malloc(1000);

	uint64_t start = hwtime(), end;
	cout << "Hello from thread " << pthread_self() << endl;
	end = hwtime();
	cout << "start: " << start << endl << "end: " << end;
}

void test_rmalloc()
{
	replace_malloc(1);
}

void test_xxmalloc()
{
	xxmalloc(2);
}

int main(int argc, char const *argv[])
{
	// test_1();
	test_xxmalloc();
	test_rmalloc();
	return 0;
}