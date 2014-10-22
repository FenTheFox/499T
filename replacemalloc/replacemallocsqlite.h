//
//  replacemallocsqlite.h
//  replacemalloc
//
//  Created by Timm Allman on 10/7/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#ifndef __replacemalloc__replacemallocsqlite__
#define __replacemalloc__replacemallocsqlite__

#include <string>

#include <sys/sysctl.h>
#include <malloc/malloc.h>
#include <libkern/OSAtomic.h>

#include <dlfcn.h>

#include "time.hpp"

//To capture any methods from libraries that don't implement all the methods sqlite uses/use different names
extern "C" {
//	void*   xxmalloc(size_t sz) __attribute__((weak_import));
//	void    xxfree(void *ptr) __attribute__((weak_import));
//	size_t  xxmalloc_usable_size (void * ptr) __attribute__((weak_import));
//	void    xxmalloc_lock() __attribute__((weak_import));
//	void    xxmalloc_unlock() __attribute__((weak_import));
}

//These are accessed from c++ code
void*   rMalloc(size_t sz);
void    rFree(void *ptr);
void*   rRealloc(void* ptr, size_t sz);
size_t  rSize(void * ptr);
size_t  rRoundup(size_t sz);
int     rInit(void* appData);
void    rEnd(void * appData);


#endif /* defined(__replacemalloc__replacemallocsqlite__) */