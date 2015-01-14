#include <sys/mman.h>
#include <unistd.h>
#include <dlfcn.h>

#include "logger.h"

void*	(*sys_mmap)		(void*, size_t, int, int, int, off_t)	= NULL;
int		(*sys_munmap)	(void*, size_t)							= NULL;
void*	(*sys_sbrk)		(int)									= NULL;
int		(*sys_brk)		(void*)									= NULL;

extern Logger* getLogger();
#define LOG(type, ptr, sz) getLogger()->log(type, ptr, sz)

void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
{
    if (!sys_mmap)
        sys_mmap = (void* (*)(void *, size_t, int, int, int, off_t))dlsym(RTLD_NEXT, "mmap");

	auto ptr = sys_mmap(addr, length, prot, flags, fd, offset);

	if (flags & MAP_ANON)
		LOG(Logger::MMAP, ptr, length);
	else
		LOG(Logger::MMAP, ptr, 0);
//		printf("not mapped anon\n");

	return ptr;
}

int munmap(void *addr, size_t length)
{
    if (!sys_munmap)
        sys_munmap = (int (*)(void *, size_t))dlsym(RTLD_NEXT, "munmap");

	LOG(Logger::MUNMAP, addr, length);

    return sys_munmap(addr, length);
}

void *sbrk(int incr)
{
    if (!sys_sbrk)
        sys_sbrk = (void* (*)(int))dlsym(RTLD_NEXT, "sbrk");

	LOG(Logger::SBRK, NULL, incr);
	
	return sys_sbrk(incr);
}

int brk(void *addr)
{
    if (!sys_brk)
        sys_brk = (int (*)(void*))dlsym(RTLD_NEXT, "brk");

	LOG(Logger::BRK, addr, 0);
	
	return sys_brk(addr);
}