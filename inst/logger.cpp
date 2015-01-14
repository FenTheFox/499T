//
//  logger.cpp
//  inst
//
//  Created by Timm Allman on 1/9/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include "logger.h"

#include <new>

#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <libkern/OSAtomic.h>

#define OPEN_FLAGS (O_WRONLY | O_APPEND | O_CREAT)
#define OPEN_MODE (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH)

Logger* getLogger(void)
{
	//Magic?
	static double lBuf[sizeof(Logger)/sizeof(double) + 1];
	static Logger *l = new (lBuf) Logger;
	return l;
}

extern "C" void doLog(enum event_type type, void* ptr, size_t sz)
{
	getLogger()->log((Logger::event_type)type, ptr, sz);
}

Logger::Logger()
{
	currMalloc = currMmap = maxMalloc = maxMmap = sinceLastFlush = 0;
	origMmapSize = map();
	origMallocSize = map();

	maxmmapf = open("max-mmap", OPEN_FLAGS, OPEN_MODE);
	tracemmapf = open("trace-mmap", OPEN_FLAGS, OPEN_MODE);
	maxmallocf = open("max-malloc", OPEN_FLAGS, OPEN_MODE);
	tracemallocf = open("trace-malloc", OPEN_FLAGS, OPEN_MODE);

	if (maxmmapf < 0 || tracemmapf < 0 || maxmallocf < 0 || tracemallocf < 0)
		write(1, "opening files failed\n", 22);
	char buf[11];
	memset(buf, 0, 11);
	sprintf(buf, "%d %d %d %d\n", maxmmapf, tracemmapf, maxmallocf, tracemallocf);
	write(1, buf, 11);
}

char* Logger::typeToS(event_type type)
{
	switch (type) {
		case MALLOC:
			return "malloc";
			break;
		case FREE:
			return "free";
			break;
		case REALLOC:
			return "realloc";
			break;
		case MEMALIGN:
			return "memalign";
			break;
		case MMAP:
			return "mmap";
			break;
		case MUNMAP:
			return "munmap";
			break;
		case BRK:
			return "brk";
			break;
		case SBRK:
			return "sbrk";
			break;
		default:
			return "NONE";
			break;
	}
}

int strlen(char*, int);

void Logger::log(event_type type, void* ptr, size_t sz)
{
	int len = 37;
	char str[len];

	if (type == MEMALIGN) {
		origMallocSize.erase((size_t)ptr);
		origMallocSize.insert((size_t)ptr, sz);
		return;
	} else if (type == SBRK || type == BRK) {
		memset(str, 0, len);
		sprintf(str, "hmmm, %s encountered D:\n", typeToS(type));
		write(1, str, strlen(str, len));
		return;
	}
	
	if (type == MMAP) {
		origMmapSize.insert((size_t)ptr, sz);
		OSAtomicAdd64(sz, &currMmap);
		if (currMmap > maxMalloc) {
			OSAtomicCompareAndSwap64(maxMmap, currMmap, &maxMmap);
			memset(str, 0, len);
			sprintf(str, "%lld\n", maxMmap);
			write(maxmmapf, str, strlen(str, len));
		}
	} else if (type == MUNMAP) {
		OSAtomicAdd64(-sz, &currMmap);
		if (sz != origMmapSize.at((size_t)ptr)) {
			if (origMmapSize.at((size_t)ptr) == 0)
				return;

			memset(str, 0, len);
			sprintf(str, "orig = %zu, munmap'd = %zu\n", origMmapSize.at((size_t)ptr), sz);
			write(tracemmapf, str, strlen(str, len));
		} else {
			origMmapSize.erase((size_t)ptr);
		}
	} else if (type == MALLOC) {
		origMallocSize.insert((size_t)ptr, sz);
		OSAtomicAdd64(sz, &currMalloc);
		if (currMalloc > maxMalloc) {
			OSAtomicCompareAndSwap64(maxMalloc, currMalloc, &maxMalloc);
			memset(str, 0, len);
			sprintf(str, "%lld\n", maxMalloc);
			write(maxmallocf, str, strlen(str, len));
		}
	} else if (type == FREE) {
		sz = origMallocSize.at((size_t)ptr);
		OSAtomicAdd64(-sz, &currMalloc);
		origMallocSize.erase((size_t)ptr);
	}

	memset(str, 0, len);
	sprintf(str, "%s %zu\n", typeToS(type), sz);
	if (type == MMAP || type == MUNMAP)
		write(tracemmapf, str, strlen(str, len));
	else if (type == MALLOC || type == FREE)
		write(tracemallocf, str, strlen(str, len));
}

int strlen(char *str, int len)
{
	for (int i = 0; i < len; i++)
		if (str[i] == '\0')
			len = i;
	return len;
}