#include <iostream>
#include <fstream>

using namespace std;

inline uint64_t hwtime(){
	unsigned int lo, hi;
	__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
	return ((uint64_t)hi << 32) | lo;
}

int main(int argc, char const *argv[])
{
	ofstream *file = new ofstream("./example.txt");
	if(!file)
	{
		cerr << "Cannot open the output file." << endl;
		return 1;
	}
	file->close();
	
	uint64_t start = hwtime(), end;
	cout << "Hello from thread " << pthread_self() << endl;
	end = hwtime();
	cout << "start: " << start << endl << "end: " << end;
	return 0;
}