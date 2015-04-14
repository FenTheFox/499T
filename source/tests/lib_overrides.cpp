#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <dlfcn.h>

#include <string>

using namespace std;

void log(int size, string from)
{
    const char *bytes = std::to_string(size).c_str(), *method = from.c_str();
    write(1, method, sizeof(method)-1);
    write(1, "'d ", 4);
    write(1, bytes, sizeof(bytes)-1);
    write(1, " bytes\n", 8);
}

void* (*system_malloc) (size_t) = NULL;
void* (*sys_mmap) (void *, size_t, int, int, int, off_t) = NULL;
int   (*sys_munmap) (void *, size_t);

void* malloc(size_t size)
{
    if (!system_malloc)
        system_malloc = (void* (*)(size_t))dlsym(RTLD_NEXT, "malloc");
		
	log(size, "malloc");	
		
    return system_malloc(size);
}

void *mmap(void *addr, size_t length, int prot, int flags, int fd, off_t offset)
{
    if (!sys_mmap)
        sys_mmap = (void* (*)(void *, size_t, int, int, int, off_t))dlsym(RTLD_NEXT, "mmap");
		
	log(length, "mmap");	
		
    return sys_mmap(addr, length, prot, flags, fd, offset);
}

int munmap(void *addr, size_t length)
{
    if (!sys_munmap)
        sys_munmap = (int (*)(void *, size_t))dlsym(RTLD_NEXT, "munmap");
		
	log(length, "munmap");	
		
    return sys_munmap(addr, length);
}