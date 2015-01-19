//
//  Logger.h
//  inst
//
//  Created by Timm Allman on 1/9/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#ifndef __inst__logger__
#define __inst__logger__

#include <stdio.h>

enum event_type {MALLOC, FREE, REALLOC, MEMALIGN, MMAP, MUNMAP, BRK, SBRK};
typedef enum event_type event_t;
#ifdef __cplusplus
extern "C"
#endif
void doLog(event_t, void*, size_t);

#ifdef __cplusplus
#include "map.h"

class Logger {
public:
	enum event_type {MALLOC, FREE, REALLOC, MEMALIGN, MMAP, MUNMAP, BRK, SBRK};

	Logger();

	void log(event_type, void*, size_t = 0);

private:
	int maxmallocf, tracemallocf, maxmmapf, tracemmapf;
	int mutex;
	int64_t currMalloc, maxMalloc, currMmap, maxMmap;
	size_t sinceLastFlush, flushThreshold;

	map origMmapSize, origMallocSize;
	
	char* typeToS(event_type);
};
#endif

#endif /* defined(__inst__logger__) */
