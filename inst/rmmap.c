#include <sys/mman.h>
#include <unistd.h>
#include <dlfcn.h>

void* (*sys_mmap) (void *, size_t, int, int, int, off_t) = NULL;
int   (*sys_munmap) (void *, size_t);

int most = 0, curr = 0;

void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
{
    if (!sys_mmap)
        sys_mmap = (void* (*)(void *, size_t, int, int, int, off_t))dlsym(RTLD_NEXT, "mmap");
		
	if (curr + length > most)
		most = curr + length;
		
    return sys_mmap(addr, length, prot, flags, fd, offset);
}

int munmap(void *addr, size_t length)
{
    if (!sys_munmap)
        sys_munmap = (int (*)(void *, size_t))dlsym(RTLD_NEXT, "munmap");
		
	curr -= length;
		
    return sys_munmap(addr, length);
}