//
//  logger.cpp
//  inst
//
//  Created by Timm Allman on 1/9/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include "logger.h"

#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define OPEN_FLAGS (O_WRONLY | O_APPEND | O_CREAT)
#define OPEN_MODE (S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH)

Logger::Logger(logger_type type) {
	this->type = type;
	curr = max = sinceLastFlush = 0;
	origSize = map();

	if (pthread_mutex_init(&lock, NULL) != 0)
		write(1, "mutex init failed\n", 19);

	if (type == SYS) {
		maxf = open("max-mmap", OPEN_FLAGS, OPEN_MODE);
		tracef = open("trace-mmap", OPEN_FLAGS, OPEN_MODE);
	} else {
		maxf = open("max-malloc", OPEN_FLAGS, OPEN_MODE);
		tracef = open("trace-malloc", OPEN_FLAGS, OPEN_MODE);
	}

	if (maxf < 0 || tracef < 0)
		write(1, "opening files failed\n", 22);
	else {
		char buf[11];
		memset(buf, 0, 11);
		sprintf(buf, "%d %d\n", maxf, tracef);
		write(1, buf, 11);
	}
}

char* typeToS(Logger::event_type type) {
	switch (type) {
		case Logger::MALLOC:
			return "malloc";
			break;
		case Logger::FREE:
			return "free";
			break;
		case Logger::REALLOC:
			return "realloc";
			break;
		case Logger::MEMALIGN:
			return "memalign";
			break;
		case Logger::MMAP:
			return "mmap";
			break;
		case Logger::MUNMAP:
			return "munmap";
			break;
		case Logger::SBRK:
			return "sbrk?";
			break;
		default:
			return "NONE";
			break;
	}
}

int strlen(char*, int);

void Logger::log(event_type type, void* ptr, size_t sz){
//	pthread_mutex_lock(&lock);
	int len;

	if(type == MEMALIGN) {
		origSize.erase((size_t)ptr);
		origSize.insert((size_t)ptr, sz);
		return;
	}
	
	if (type == MMAP || type == MALLOC) {
		origSize.insert((size_t)ptr, sz);
		curr += sz;
		if (curr > max) {
			max = curr;
			len = 23;
			char m[len];
			memset(m, 0, len);
			sprintf(m, "%zu\n", max);
			len = strlen(m, len);
			write(maxf, m, len);
		}
	} else if (type == MUNMAP) {
		curr -= sz;
//		if (sz != origSize.at((size_t)ptr)) {
//			fprintf(tracef, "wut, orig = %zu, munmap'd = %zu", origSize.at((size_t)ptr), sz);
//		}
		origSize.erase((size_t)ptr);
	} else if (type == FREE) {
		curr -= origSize.at((size_t)ptr);
		origSize.erase((size_t)ptr);
	}

	len = 31;
	char buff[len];
	memset(buff, 0, len);
	sprintf(buff, "%s %zu\n", typeToS(type), curr);
	len = strlen(buff, len);
	write(tracef, buff, len);

//	pthread_mutex_unlock(&lock);
}

int strlen(char *str, int len) {
	for (int i = 0; i < len; i++)
		if (str[i] == '\0')
			len = i;
	return len;
}