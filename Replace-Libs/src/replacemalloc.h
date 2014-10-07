//
//  replacemalloc.h
//  
//
//  Created by Timm Allman on 9/23/14.
//
//

#ifndef ____replacemalloc__
#define ____replacemalloc__

#include <stdlib.h>
#include <unistd.h>
#include <cstdio>

extern "C" {
	void *xxmalloc(size_t sz) __attribute__((weak_import));
	void xxfree(void *ptr) __attribute__((weak_import));
	size_t xxmalloc_usable_size (void * ptr) __attribute__((weak_import));
	void xxmalloc_lock() __attribute__((weak_import));
	void xxmalloc_unlock() __attribute__((weak_import));
}

void* replace_malloc(size_t size);

#endif /* defined(____replacemalloc__) */
