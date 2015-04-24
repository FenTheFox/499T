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

	long diff() {
		if (start_time == steady_clock::time_point::min() || end_time == steady_clock::time_point::min())
			std::cerr << "Please call both start() and end() in between each call to duration()" << std::endl;

		auto ret = duration_cast<nanoseconds>(end_time - start_time);

		return ret.count();
	}

  public:
	timer() {
		start_time = steady_clock::time_point::min();
		end_time = steady_clock::time_point::min();
		total = 0;
	}

	void start() {
		start_time = steady_clock::now();
	}

	void end() {
		end_time = steady_clock::now();

		total += diff();
	}

	long total_duration() { return total; }

	void merge(timer t) {
		total += t.total_duration();
	}
};