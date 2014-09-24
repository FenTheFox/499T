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
    char str[30] = "Bytes requested from malloc: ",
    s[sizeof(size_t)] = "",
    end[2] = "\n";
    snprintf(s, sizeof(size_t), "%zu", size);
    
    write(1, str, 29);
    write(1, s, sizeof(size_t));
    write(1, end, sizeof(end));
    
    
    return malloc(size);
}
