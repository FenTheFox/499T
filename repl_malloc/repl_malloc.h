#include <unistd.h>

#ifdef __cplusplus
extern "C" {
#endif
void *replace_malloc(size_t size);
void *replace_calloc(size_t num, size_t size);
void *replace_realloc(void *ptr, size_t size);
void replace_free(void *ptr);
void *replace_memalign(size_t alignment, size_t size);
int replace_posix_memalign(void **ptr, size_t alignment, size_t size);
void *replace_aligned_alloc(size_t alignment, size_t size);
void *replace_valloc(size_t size);
size_t replace_malloc_usable_size(void* ptr);
size_t replace_malloc_good_size(size_t size);
#ifdef __cplusplus
}
#endif