//
//  cmain.c
//  inst
//
//  Created by Timm Allman on 1/14/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include <stdio.h>
#include <sys/mman.h>

#include "logger.h"

int main()
{
	void* ptr = mmap(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	doLog(MALLOC, ptr, 1024);
}