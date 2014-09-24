/*
* compile with:
* 	clang++ example.cpp -I./source
*/

#include <iostream>
#include <fstream>
#include <stdlib.h>

#include "hwtime.h"

using namespace std;

int main(int argc, char const *argv[])
{
	ofstream *file = new ofstream("./example.txt");
	if(!file)
	{
		cerr << "Cannot open the output file." << endl;
		return 1;
	}
	file->close();
	
	replace_malloc(10);
	replace_malloc(100);
	replace_malloc(1000);

	uint64_t start = hwtime(), end;
	cout << "Hello from thread " << pthread_self() << endl;
	end = hwtime();
	cout << "start: " << start << endl << "end: " << end;
	return 0;
}