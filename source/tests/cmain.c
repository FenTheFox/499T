//
//  cmain.c
//  inst
//
//  Created by Timm Allman on 1/14/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>
#include <sys/mman.h>

#include "logger.h"

int main()
{
	void* ptr = mmap(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	// void *handle, *ptr;
	// void* (*mmap_ptr)(void*, size_t, int, int, int, off_t);
	// char *error;

	// handle = dlopen("libc-2.20.so", RTLD_LAZY);
	// if (!handle) {
	// 	fprintf(stderr, "%s\n", dlerror());
	// 	exit(EXIT_FAILURE);
	// }

	// dlerror();    /* Clear any existing error */

	// *(void **) (&mmap_ptr) = dlsym(handle, "mmap");

	// if ((error = dlerror()) != NULL)  {
	// 	fprintf(stderr, "%s\n", error);
	// 	exit(EXIT_FAILURE);
	// }

	// ptr = (*mmap_ptr)(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	// dlclose(handle);
	// exit(EXIT_SUCCESS);
}