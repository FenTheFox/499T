/*
 * compile with: clang++ -dynamiclib ffreplacelib.cpp -o ffreplace.dylib -std=c++11 -stdlib=libc++ -I ~/Honors/Replace-Libs -I ~/Honors/Malloc-Implementations/Heap-Layers -I ~/Honors/Firefox-Stuff/src/obj-x86_64-apple-darwin13.1.0-replace/dist/include/
*/

#define PAGE_SIZE 1024

#include <iostream>
#include <fstream>
#include <list>
#include <array>
#include <map>

#include "replace_malloc.h"

using namespace std;

static const malloc_table_t *funcs;

void replace_exit() {}

void replace_init(const malloc_table_t *table) {
	funcs = table;

	atexit(replace_exit);
}

void *replace_malloc(size_t size) {
	return funcs->malloc(size);
}

void *replace_calloc(size_t num, size_t size){
	return funcs->calloc(num, size);
}

void *replace_realloc(void *ptr, size_t size){
	return funcs->realloc(ptr, size);
}

void replace_free(void *ptr){
	funcs->free(ptr);
}

void *replace_memalign(size_t alignment, size_t size){
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

void *replace_valloc(size_t size){
	return funcs->valloc(size);
}

size_t replace_malloc_usable_size(usable_ptr_t ptr){
	return funcs->malloc_usable_size(ptr);
}

size_t replace_malloc_good_size(size_t size){
	return funcs->malloc_good_size(size);
}