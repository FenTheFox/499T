#include <unistd.h>

#ifdef __cplusplus
extern "C" {
#endif
void *	repl_mmap(void*, size_t, int, int, int, off_t);
void *	repl_mremap(void*, size_t, size_t, int);
int		repl_munmap(void*, size_t);
int		repl_brk(void*);
void *	repl_sbrk(intptr_t);
#ifdef __cplusplus
}
#endif