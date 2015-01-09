#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>

#include "hwtime.h"

int main(int argc, char const *argv[])
{	
	void *helloptr = malloc(10), *worldptr = malloc(100),
		*thing = mmap(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	munmap (thing, 1024);
	
	printf("Malloc'd %d bytes\n", 110);

	return 0;
}