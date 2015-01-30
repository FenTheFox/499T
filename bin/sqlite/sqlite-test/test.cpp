#include "time.h"

int main(int argc, char const *argv[])
{
	std::cout << sizeof(size_t) << std::endl;
	timer t = timer();
	t.start();
	std::cout << "printing 1000 stars:" << std::endl;
	for (int i = 0; i < 1000; ++i) std::cout << "*";
	std::cout << std::endl;
	t.end();

	std::cout << "it took " << t.total_duration() << " nanoseconds" << std::endl
	     << "or " << t.hwtotal_duration() << " hw nanoseconds" << std::endl;

	return 0;
}

// #include <iostream>
// #include <ctime>
// #include <ratio>
// #include <chrono>

// int main ()
// {
//   using namespace std::chrono;

//   steady_clock::time_point t1 = steady_clock::now();

//   std::cout << "printing out 1000 stars...\n";
//   for (int i=0; i<1000; ++i) std::cout << "*";
//   std::cout << std::endl;

//   steady_clock::time_point t2 = steady_clock::now();

//   duration<double> time_span = duration_cast<duration<double>>(t2 - t1);

//   std::cout << "It took me " << time_span.count() << " seconds.";
//   std::cout << std::endl;

//   return 0;
// }