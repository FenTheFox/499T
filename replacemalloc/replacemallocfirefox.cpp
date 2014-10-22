//
//  replacemallocfirefox.cpp
//  replacemalloc
//
//  Created by Timm Allman on 10/7/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#include "replacemallocfirefox.h"

#include "replace_malloc.h"

using namespace std;

static const malloc_table_t *funcs;

void replace_exit() {}

void replace_init(const malloc_table_t *table)
{
	funcs = table;
	atexit(replace_exit);
}

void *replace_malloc(size_t size)
{
	return funcs->malloc(size);
}

void *replace_calloc(size_t num, size_t size)
{
	return funcs->calloc(num, size);
}

void *replace_realloc(void *ptr, size_t size)
{
	return funcs->realloc(ptr, size);
}

void replace_free(void *ptr)
{
	funcs->free(ptr);
}

void *replace_memalign(size_t alignment, size_t size)
{
	return funcs->memalign(alignment, size);
}

int replace_posix_memalign(void **ptr, size_t alignment, size_t size)
{
	return funcs->posix_memalign(ptr, alignment, size);
}

void *replace_aligned_alloc(size_t alignment, size_t size)
{
	return funcs->aligned_alloc(alignment, size);
}

void *replace_valloc(size_t size)
{
	return funcs->valloc(size);
}

size_t replace_malloc_usable_size(usable_ptr_t ptr)
{
	return funcs->malloc_usable_size(ptr);
}

size_t replace_malloc_good_size(size_t size)
{
	return funcs->malloc_good_size(size);
}