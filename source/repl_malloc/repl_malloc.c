#include <unistd.h>
#include <errno.h>

#include "repl_malloc.h"

#if defined(REPL_NEDMALLOC)
size_t replace_memsize(void* ptr);

int replace_posix_memalign(void **ptr, size_t alignment, size_t size)
{
	if (size == 0) {
		*ptr = NULL;
		return 0;
	}
	/* alignment must be a power of two and a multiple of sizeof(void *) */
	if (((alignment - 1) & alignment) != 0 || (alignment % sizeof(void *)))
		return EINVAL;
	*ptr = replace_memalign(alignment, size);
	return *ptr ? 0 : ENOMEM;
}

void *replace_valloc(size_t size)
{
	return replace_memalign(sysconf(_SC_PAGESIZE), size);
}

size_t replace_malloc_usable_size(void* ptr)
{
	return replace_memsize(ptr);
}
#endif

#if defined(REPL_NEDMALLOC) || defined(REPL_PTMALLOC)
void *replace_aligned_alloc(size_t alignment, size_t size)
{
	/* size should be a multiple of alignment */
	if (size % alignment)
		return NULL;
	return replace_memalign(alignment, size);
}
#endif

size_t replace_malloc_good_size(size_t size)
{
	return size;
}