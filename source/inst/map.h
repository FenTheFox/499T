//
//  map.h
//  inst
//
//  Created by Timm Allman on 1/10/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#ifndef __inst__map__
#define __inst__map__

#define ARR_SIZE 20000
#define LIST_SIZE 2048

#include <stdio.h>

struct pair_t {
	size_t first;
	size_t second;
	bool active;
};

class lmap {
	pair_t values [ARR_SIZE][LIST_SIZE];
public:
	void init();
	size_t at(size_t);
	void erase(size_t);
	void insert(size_t, size_t);
};

#endif /* defined(__inst__map__) */
