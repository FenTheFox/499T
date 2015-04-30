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

class timer {
	std::chrono::steady_clock::time_point start_time, end_time;
	std::chrono::duration<long double, std::milli> total;

public:
	typedef std::chrono::steady_clock clock_type;
	typedef std::chrono::duration<long double, std::milli> duration_type;
	
	timer() {
		start_time = clock_type::time_point::min();
		end_time = clock_type::time_point::min();
		total = std::chrono::duration_values<std::chrono::milliseconds>::zero();
	}

	void start() {
		start_time = clock_type::now();
	}

	void end() {
		end_time = clock_type::now();
		if (start_time == clock_type::time_point::min())
			std::cerr << "Please call start() in between each call to end()" << std::endl;

		total += end_time - start_time;
	}
	
	void merge(timer t) {
		total += t.dur();
	}

	duration_type dur() { return total; }
};