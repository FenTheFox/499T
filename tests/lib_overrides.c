#include <stdlib.h>
#include <unistd.h>
#include <dlfcn.h>

void* (*system_malloc) (size_t) = NULL;

void* malloc(size_t size)
{
    if (!system_malloc)
        system_malloc = dlsym(RTLD_NEXT, "malloc");
		
		char s[sizeof(size_t)] = "";
		snprintf(s, sizeof(size_t), "%zu", size);
    
    write(1, "Bytes requested from malloc: ", 29);
		write(1, s, sizeof(size_t));
		write(1, "\n", 2);
		
		
    return system_malloc(size);
}