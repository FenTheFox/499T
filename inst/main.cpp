//
//  main.cpp
//  inst
//
//  Created by Timm Allman on 1/9/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

#include "logger.h"
#include "map.h"

extern Logger* getLogger();

int main()
{
	void *ptr1 = mmap(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0),
		*ptr2 = mmap(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE, -1, 0),
		*ptr3 = malloc(1024);

	munmap(ptr1, 1024);
	munmap(ptr2, 1024);
	free(ptr3);

	getLogger()->log(Logger::MALLOC, NULL, 1);

//	printf("hello world %llu\n", SIZE_MAX);
}