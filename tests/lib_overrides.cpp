#include <stdlib.h>
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

void* malloc(size_t size)
{
    if (!system_malloc)
        system_malloc = (void *(*)(size_t))dlsym(RTLD_NEXT, "malloc");
		
		log(size, "malloc");	
		
    return system_malloc(size);
}