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
	origMmapSize = lmap();
	origMallocSize = lmap();

	maxf = open("max", OPEN_FLAGS, OPEN_MODE);
	tracef = open("trace", OPEN_FLAGS, OPEN_MODE);

	if (maxf < 0)
		write(1, "opening files failed\n", 22);
	char buf[11];
	memset(buf, 0, 11);
	snprintf(buf, 11, "%d\n", maxf);
	// write(1, buf, 11);
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
		snprintf(str, len, "hmmm, %s encountered D:\n", typeToS(type));
		write(1, str, strlen(str, len));
		return;
	}
	
	if (type == MMAP) {
		origMmapSize.insert((size_t)ptr, sz);
		currMmap += sz;
		// OSAtomicAdd64(sz, &currMmap);
		if (currMmap > maxMmap) {
			// OSAtomicCompareAndSwap64(maxMmap, currMmap, &maxMmap);
			maxMmap = currMmap;
			memset(str, 0, len);
			snprintf(str, len, "mmap %ld\n", maxMmap);
			write(maxf, str, strlen(str, len));
		}
	} else if (type == MUNMAP) {
		// OSAtomicAdd64(-sz, &currMmap);
		currMmap -= sz;
		if (sz != origMmapSize.at((size_t)ptr)) {
			if (origMmapSize.at((size_t)ptr) == 0)
				return;

			size_t oldSz = origMmapSize.at((size_t)ptr), change = oldSz - sz;
			origMmapSize.erase((size_t)ptr);
			origMmapSize.insert((size_t)ptr+change, oldSz - change);
		}
	} else if (type == MALLOC) {
		origMallocSize.insert((size_t)ptr, sz);
		currMalloc += sz;
		// OSAtomicAdd64(sz, &currMalloc);
		if (currMalloc > maxMalloc) {
			maxMalloc = currMalloc;
			// OSAtomicCompareAndSwap64(maxMalloc, currMalloc, &maxMalloc);
			memset(str, 0, len);
			snprintf(str, len, "malloc %ld\n", maxMalloc);
			write(maxf, str, strlen(str, len));
		}
	} else if (type == FREE) {
		if(ptr == NULL)
			return;
		sz = origMallocSize.at((size_t)ptr);
		currMalloc -= sz;
		// OSAtomicAdd64(-sz, &currMalloc);
		origMallocSize.erase((size_t)ptr);
	}

	// if(ptr == NULL)
	// 	write(1, "null passed to log\n", 19);

	memset(str, 0, len);
	if (type == MMAP || type == MUNMAP)
		snprintf(str, len, "%s %ld\n", typeToS(type), currMmap);
	else if (type == MALLOC || type == FREE)
		snprintf(str, len, "%s %ld\n", typeToS(type), currMalloc);
	write(tracef, str, strlen(str, len));
}