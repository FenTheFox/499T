#include "replace_malloc.h"
#include <unistd.h>

#define MACWRAPPER_PREFIX(n) macwrapper_##n

void *	MACWRAPPER_PREFIX(malloc) (size_t sz);
size_t	MACWRAPPER_PREFIX(malloc_usable_size) (usable_ptr_t ptr);
void	MACWRAPPER_PREFIX(free) (void * ptr);
size_t	MACWRAPPER_PREFIX(malloc_good_size) (size_t sz);
void *	MACWRAPPER_PREFIX(realloc) (void * ptr, size_t sz);
void *	MACWRAPPER_PREFIX(calloc) (size_t elsize, size_t nelems);
void *	MACWRAPPER_PREFIX(memalign) (size_t alignment, size_t size);
int		MACWRAPPER_PREFIX(posix_memalign) (void **memptr, size_t alignment, size_t size);
void *	MACWRAPPER_PREFIX(valloc) (size_t sz);

static const malloc_table_t *funcs;

void replace_exit() {}

void replace_init(const malloc_table_t *table)
{
	// write(1, "replace_init\n", 13);
	funcs = table;
	// atexit(replace_exit);
}

void *replace_malloc(size_t size)
{
	return MACWRAPPER_PREFIX(malloc)(size);
}

void *replace_calloc(size_t num, size_t size)
{
	return MACWRAPPER_PREFIX(calloc)(num, size);
}

void *replace_realloc(void *ptr, size_t size)
{
	return MACWRAPPER_PREFIX(realloc)(ptr, size);
}

void replace_free(void *ptr)
{
	MACWRAPPER_PREFIX(free)(ptr);
}

void *replace_memalign(size_t alignment, size_t size)
{
	return MACWRAPPER_PREFIX(memalign)(alignment, size);
}

int replace_posix_memalign(void **ptr, size_t alignment, size_t size)
{
	return MACWRAPPER_PREFIX(posix_memalign)(ptr, alignment, size);
}

void *replace_aligned_alloc(size_t alignment, size_t size)
{
    if (size % alignment)
      return NULL;
	
	return MACWRAPPER_PREFIX(memalign)(alignment, size);
}

void *replace_valloc(size_t size)
{
	return MACWRAPPER_PREFIX(valloc)(size);
}

size_t replace_malloc_usable_size(usable_ptr_t ptr)
{
	return MACWRAPPER_PREFIX(malloc_usable_size)(ptr);
}

size_t replace_malloc_good_size(size_t size)
{
	return MACWRAPPER_PREFIX(malloc_good_size)(size);
}