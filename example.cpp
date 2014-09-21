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
	uint64_t start = hwtime(), end;
	ofstream *file = new ofstream("./example.txt");
	if(!file)
	{
		cerr << "Cannot open the output file." << endl;
		return 1;
	}
	*file << "Hello from thread " << pthread_self() << endl;
	end = hwtime();
	*file << "start: " << start << endl << "end: " << end;
	file->close();
	return 0;
}