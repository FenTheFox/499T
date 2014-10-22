//
//  replacemallocsqlite.cpp
//  replacemalloc
//
//  Created by Timm Allman on 10/7/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#include "replacemallocsqlite.h"

using namespace std;

extern "C" {
void* malloc_zone_malloc(malloc_zone_t *z, size_t sz)
{
	printf("malloc_zone_malloc'd %zu bytes\n", sz);
	return malloc(sz);
}
}

void* rMalloc(size_t sz)
{
	return NULL;
}

void rFree(void *ptr){}

void* rRealloc(void* ptr, size_t sz)
{
	return NULL;
}

size_t rSize(void * ptr)
{
	return 0;
}

size_t rRoundup(size_t sz)
{
	return 0;
}

int rInit(void* appData)
{
	return 0;
}

void rEnd(void * appData){}