//
//  custom_wrapper.cpp
//  replacemalloc
//
//  Created by Timm Allman on 10/28/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#include <stdlib.h>

extern "C" {
void *malloc(size_t);
void free(void *);

// Takes a pointer and returns how much space it holds.
size_t malloc_usable_size(void *);

#ifdef LOCK_FUNC
// Locks the heap(s), used prior to any invocation of fork().
void LOCK_FUNC(lock)(void);

// Unlocks the heap(s), after fork().
void LOCK_FUNC(unlock)(void);
#endif
}

#ifndef CUSTOM_PREFIX
#define CUSTOM_PREFIX(x) xx##x
#endif

#define CUSTOM_MALLOC(x) CUSTOM_PREFIX(malloc)(x)
#define CUSTOM_FREE(x) CUSTOM_PREFIX(free)(x)
#define CUSTOM_MALLOC_USABLE_SIZE(x) CUSTOM_PREFIX(malloc_usable_size)(x)
#define CUSTOM_MALLOC_LOCK(x) CUSTOM_PREFIX(malloc_lock)(x)
#define CUSTOM_MALLOC_UNLOCK(x) CUSTOM_PREFIX(malloc_unlock)(x)

extern "C" void *CUSTOM_MALLOC(size_t sz) { return malloc(sz); }
extern "C" void CUSTOM_FREE(void *ptr) { free(ptr); }
extern "C" size_t CUSTOM_MALLOC_USABLE_SIZE(void *ptr) { return malloc_usable_size(ptr); }
#ifdef LOCK_FUNC
extern "C" void CUSTOM_MALLOC_LOCK() { return malloc_lock(); }
extern "C" void CUSTOM_MALLOC_UNLOCK() { return malloc_unlock(); }
#endif