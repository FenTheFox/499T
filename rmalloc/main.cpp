//
//  main.c
//  rmalloc
//
//  Created by Timm Allman on 1/16/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include "replace_malloc.h"

int main()
{
	malloc_table_t mt = malloc_table_t();
	mt.malloc = malloc;
	mt.free = free;
	replace_init(&mt);
	void *ptr = replace_malloc(1024);
	replace_free(ptr);
	printf("Hi\n");
	return 0;
}