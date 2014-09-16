#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char const *argv[])
{
	ofstream *file = new ofstream("/Users/Timm/Honors/example.txt");
	if(!file)
	{
		std::cerr << "Cannot open the output file." << std::endl;
		return 1;
	}
	*file << "Hello from thread " << pthread_self() << std::endl;
	file->close();
	return 0;
}