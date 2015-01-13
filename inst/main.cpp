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

//extern "C" void* macwrapper_malloc(size_t);
//extern "C" void* macwrapper_free(void*);

int main()
{
	void *ptr1 = mmap(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0),
//		*ptr2 = macwrapper_malloc(1024),
		*ptr3 = malloc(1024);
	munmap(ptr1, 1024);
//	macwrapper_free(ptr2);
	free(ptr3);

//	printf("hello world %llu\n", SIZE_MAX);
}