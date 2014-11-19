//
//  time.h
//
//  Created by Timm Allman on 9/24/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#include <chrono>
#include <iostream>

using namespace std::chrono;

class timer {
	steady_clock::time_point start_time, end_time;
	double total;

	uint64_t hwstart, hwend, hwtotal;

	uint64_t hwtime() {
		uint64_t val;
		__asm__ __volatile__("rdtsc" : "=A"(val));
		return val;
	}

	double diff() {
		if (start_time == steady_clock::time_point::min() || end_time == steady_clock::time_point::min())
			std::cerr << "Please call both start() and end() in between each call to duration()" << std::endl;

		return std::chrono::duration<double, std::nano>(end_time - start_time).count();
	}

	uint64_t hwdiff() {
		if (hwstart == 0 || hwend == 0)
			std::cerr << "Please call both start() and end() in between each call to hwduration()" << std::endl;

		return hwend - hwstart;
	}

  public:
	timer() {
		start_time = end_time = steady_clock::time_point::min();
		total = 0;

		hwstart = hwend = hwtotal = 0;
	}

	void start() {
		start_time = steady_clock::now();
		hwstart = hwtime();
	}

	void end() {
		end_time = steady_clock::now();
		hwend = hwtime();

		total += diff();
		hwtotal += hwdiff();
	}

	double duration() {
		double dur = diff();
		start_time = end_time = steady_clock::time_point(steady_clock::time_point::min());
		return dur;
	}

	uint64_t hwduration() {
		uint64_t diff = hwdiff();
		hwstart = hwend = 0;
		return diff;
	}

	double total_duration() { return total; }

	uint64_t hwtotal_duration() { return hwtotal; }

	void merge(timer t) {
		total += t.total_duration();
		hwtotal += t.hwtotal_duration();
	}
};