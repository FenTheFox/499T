#include <unistd.h>
#include <malloc/malloc.h>

#include <string>
#include <iostream>

#include "sqlite3.h"

using namespace std;

void log(int size, string from)
{
    const char* bytes = to_string(size).c_str(), *method = from.c_str();
    write(1, method, sizeof(method)-1);
    write(1, "'d ", 4);
    write(1, bytes, sizeof(bytes)-1);
    write(1, " bytes\n", 8);
}

void* replace_malloc(int size)
{
    log(size, "Malloc");
    return malloc(size);
}

void replace_free(void* ptr)
{
	free(ptr);
}

void* replace_realloc(void* ptr, int size)
{
    log(size, "Realloc");
    return realloc(ptr, size);
}

int replace_size(void* ptr)
{
    return (int)malloc_size(ptr);
}

int replace_roundup(int size)
{
    return size;
}

int init(void *param)
{
    return 0;
}

void shutdown(void* ptr)
{
    
}

int main(int argc, char *argv[])
{
    sqlite3_mem_methods *mem_methods = new sqlite3_mem_methods;
    mem_methods->xMalloc = &replace_malloc;
    mem_methods->xFree = &replace_free;
    mem_methods->xRealloc = &replace_realloc;
    mem_methods->xSize = &replace_size;
    mem_methods->xRoundup = &replace_roundup;
    mem_methods->xInit = &init;
    mem_methods->xShutdown = &shutdown;
    
    sqlite3 *db;
    
    sqlite3_config(SQLITE_CONFIG_MALLOC, mem_methods);
    
    sqlite3_open(":memory:", &db);
    
    return 0;
}