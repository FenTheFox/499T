#include <sys/mman.h>
#include <unistd.h>
#include <dlfcn.h>

#include "logger.h"

void* (*sys_mmap) (void *, size_t, int, int, int, off_t)	= NULL;
int   (*sys_munmap) (void *, size_t)						= NULL;

Logger mmapLogger = Logger(Logger::SYS);

void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
{
    if (!sys_mmap)
        sys_mmap = (void* (*)(void *, size_t, int, int, int, off_t))dlsym(RTLD_NEXT, "mmap");

	auto ptr = sys_mmap(addr, length, prot, flags, fd, offset);
	mmapLogger.log(Logger::MMAP, ptr, length);
	return ptr;
}

int munmap(void *addr, size_t length)
{
    if (!sys_munmap)
        sys_munmap = (int (*)(void *, size_t))dlsym(RTLD_NEXT, "munmap");

	mmapLogger.log(Logger::MUNMAP, addr, length);

    return sys_munmap(addr, length);
}