#include <unistd.h>

#define WEAK(x) __attribute__ ((weak, alias(#x)))

void*	__replace_malloc(size_t size) { return NULL; }
void*	__replace_realloc(void *ptr, size_t size) { return NULL; }
void	__replace_free(void *ptr) {}
size_t	__replace_malloc_usable_size(void* ptr) { return 0; }

#ifdef __cplusplus
extern "C" {
#endif
void *replace_malloc(size_t size) WEAK(__replace_malloc);
void *replace_calloc(size_t num, size_t size);
void *replace_realloc(void *ptr, size_t size) WEAK(__replace_realloc);
void replace_free(void *ptr) WEAK(__replace_free);
void *replace_memalign(size_t alignment, size_t size);
int replace_posix_memalign(void **ptr, size_t alignment, size_t size);
void *replace_aligned_alloc(size_t alignment, size_t size);
void *replace_valloc(size_t size);
size_t replace_malloc_usable_size(void* ptr) WEAK(__replace_malloc_usable_size);
size_t replace_malloc_good_size(size_t size);
#ifdef __cplusplus
}
#endif