//
//  Logger.h
//  inst
//
//  Created by Timm Allman on 1/9/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#ifndef __inst__logger__
#define __inst__logger__

#include "map.h"
#include <stdio.h>
#include <pthread.h>

class Logger {
public:
	enum logger_type {LIBC, SYS};
	enum event_type {MALLOC, FREE, REALLOC, MEMALIGN, MMAP, MUNMAP, SBRK};

	Logger(logger_type);

	void log(event_type, void*, size_t = 0);

private:
	int maxf, tracef;
	logger_type type;
	pthread_mutex_t lock;
	size_t curr, max, sinceLastFlush, flushThreshold;

	map origSize;
};

#endif /* defined(__inst__logger__) */
