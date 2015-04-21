//
//  main.cpp
//  inst
//
//  Created by Timm Allman on 1/9/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

#include "logger.h"
#include "map.h"

#include <iostream>

extern Logger* getLogger();

using namespace std;

int main()
{
	void *mallocptr = malloc(1024), *mmapptr = mmap(NULL, 1024, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	getLogger()->log(Logger::MMAP, mmapptr, 1024);
	getLogger()->log(Logger::MALLOC, mallocptr, 1024);
	getLogger()->log(Logger::MUNMAP, mmapptr, 1024);
	getLogger()->log(Logger::FREE, mallocptr, 1024);
}