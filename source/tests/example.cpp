/*
* compile with:
* 	clang++ example.cpp -I./source
*/

extern "C" {
	int xxfunc1(int);
	void xxfunc2(long);
}

#ifndef CUSTOM_PREFIX
#define CUSTOM_PREFIX(x) x
#endif

#define CUSTOM_MALLOC(x)     CUSTOM_PREFIX(malloc)(x)
#define CUSTOM_FREE(x)       CUSTOM_PREFIX(free)(x)

int func1(int i)
{
	return i;
}

void func2(long l){};

extern "C" int CUSTOM_MALLOC (int i)
{
	return func1(i);
}

extern "C" void CUSTOM_FREE(long l)
{
	func2(l);
}

// extern "C" void *xxmalloc(size_t size) __attribute__((weak_import));
//
// void test_1()
// {
// 	ofstream *file = new ofstream("./example.txt");
// 	if(!file)
// 	{
// 		cerr << "Cannot open the output file." << endl;
// 		return;
// 	}
// 	file->close();
//
// 	replace_malloc(10);
// 	replace_malloc(100);
// 	replace_malloc(1000);
//
// 	uint64_t start = hwtime(), end;
// 	cout << "Hello from thread " << pthread_self() << endl;
// 	end = hwtime();
// 	cout << "start: " << start << endl << "end: " << end;
// }
//
// void test_rmalloc()
// {
// 	replace_malloc(1);
// }
//
// void test_xxmalloc()
// {
// 	xxmalloc(2);
// }
//
// int main(int argc, const char *argv[])
// {
// 	test_1();
// 	test_xxmalloc();
// 	test_rmalloc();
// 	return 0;
// }