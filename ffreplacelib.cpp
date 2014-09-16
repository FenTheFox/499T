/*
 * compile with clang++ -dynamiclib heaplayers.cpp -o heaplayers.dylib -std=c++11 -stdlib=libc++ -I ~/Honors/Replace-Libs -I ~/Honors/Malloc-Implementations/Heap-Layers -I ~/Honors/Firefox-Stuff/release-src/obj-x86_64-apple-darwin13.1.0-replace/dist/include
*/

#define MOZ_REPLACE_ONLY_MEMALIGN
#define PAGE_SIZE 1024

#include <iostream>
#include <list>
#include <array>
#include <map>

#include "replace_malloc.h"
#include "trackheap.h"

using namespace HL;
class ReplaceHeap : public TrackHeap<MallocHeap> {};

static ReplaceHeap *heap = new ReplaceHeap;
static const malloc_table_t *funcs = NULL;
static std::map<pthread_t, std::array<std::list<uint64_t>, 7>> *tlogs = NULL;
enum funcs
{
	MALLOC = 0,
	CALLOC = 1,
	REALLOC = 2,
	FREE = 3,
	MEMALIGN = 4,
	MALLOC_USABLE_SIZE = 5,
	MALLOC_GOOD_SIZE = 6
};

void replace_init(const malloc_table_t *table) {
	std::cout << "replace_init";
	funcs = table;
	tlogs = new std::map<pthread_t, std::array<std::list<uint64_t>, 7>>;
}

void *replace_malloc(size_t size) {
	return heap->malloc(size, &(tlogs->at(pthread_self())[MALLOC]));
}

void *replace_calloc(size_t num, size_t size){
	return funcs->calloc(num, size);
}

void *replace_realloc(void *ptr, size_t size){
	return funcs->realloc(ptr, size);
}

void replace_free(void *ptr){
	heap->free(ptr, &(tlogs->at(pthread_self())[FREE]));
}

void *replace_memalign(size_t alignment, size_t size){
	return funcs->memalign(alignment, size);
}

size_t replace_malloc_usable_size(usable_ptr_t ptr){
	return funcs->malloc_usable_size(ptr);
}

size_t replace_malloc_good_size(size_t size){
	return funcs->malloc_good_size(size);
}