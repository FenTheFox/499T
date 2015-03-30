//
//  time.h
//
//  Created by Timm Allman on 9/24/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#include <chrono>
#include <iostream>
#include <ctime>
#include <ratio>

using namespace std::chrono;

class timer {
	steady_clock::time_point start_time, end_time;
	long total;

	// uint64_t hwstart, hwend, hwtotal;

	// uint64_t hwtime() {
		// uint64_t val;
		// __asm__ __volatile__("rdtsc" : "=A"(val));
		// return val;
	// }

	long diff() {
		if (start_time == steady_clock::time_point::min() || end_time == steady_clock::time_point::min())
			std::cerr << "Please call both start() and end() in between each call to duration()" << std::endl;

		auto ret = duration_cast<nanoseconds>(end_time - start_time);

		return ret.count();
	}

	// uint64_t hwdiff() {
		// if (hwstart == 0 || hwend == 0)
			// std::cerr << "Please call both start() and end() in between each call to hwduration()" << std::endl;

		// return hwend - hwstart;
	// }

  public:
	timer() {
		start_time = steady_clock::time_point::min();
		end_time = steady_clock::time_point::min();
		total = 0;

		hwstart = hwend = hwtotal = 0;
	}

	void start() {
		start_time = steady_clock::now();
		// hwstart = hwtime();
	}

	void end() {
		end_time = steady_clock::now();
		// hwend = hwtime();

		total += diff();
		// hwtotal += hwdiff();
	}

	long total_duration() { return total; }

	// uint64_t hwtotal_duration() { return hwtotal; }

	void merge(timer t) {
		total += t.total_duration();
		// hwtotal += t.hwtotal_duration();
	}
};