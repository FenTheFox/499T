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
static map<pthread_t, array<list<uint64_t>, 10> > *tlogs = new map<pthread_t, array<list<uint64_t>, 10> >();
enum func_ids
{
	MALLOC, CALLOC, REALLOC, FREE, MEMALIGN, POSIX_MEMALIGN, ALIGNED_ALLOC, VALLOC, MALLOC_USABLE_SIZE,	MALLOC_GOOD_SIZE
};

uint64_t hwtime() {
	unsigned int lo, hi;
	__asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
	return (uint64_t)hi << 32 | lo;
}

void write_log() {
	ofstream logf ("/Users/Timm/Honors/log.txt");
	logf << "exited at " << hwtime() << endl;
}

void replace_init(const malloc_table_t *table) {
	funcs = table;
	cout << "replace_init at " << hwtime() << endl;

	atexit(write_log);
}

//TODO: Implement custom allocator for map/array/list so it doesn't call this function
void *replace_malloc(size_t size) {
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->malloc(size);
}

void *replace_calloc(size_t num, size_t size){
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->calloc(num, size);
}

void *replace_realloc(void *ptr, size_t size){
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->realloc(ptr, size);
}

void replace_free(void *ptr){
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	funcs->free(ptr);
}

void *replace_memalign(size_t alignment, size_t size){
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->memalign(alignment, size);
}

int replace_posix_memalign(void **ptr, size_t alignment, size_t size)
{
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->posix_memalign(ptr, alignment, size);
}

void *replace_aligned_alloc(size_t alignment, size_t size)
{
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->aligned_alloc(alignment, size);
}

void *replace_valloc(size_t size){
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->valloc(size);
}

size_t replace_malloc_usable_size(usable_ptr_t ptr){
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->malloc_usable_size(ptr);
}

size_t replace_malloc_good_size(size_t size){
	// tlogs->at(pthread_self())[MALLOC].push_back(hwtime());
	return funcs->malloc_good_size(size);
}