//
//  replacemalloc.cpp
//  
//
//  Created by Timm Allman on 9/23/14.
//
//

#include "replacemalloc.h"

void* replace_malloc(size_t size)
{    
    return xxmalloc(size);
}