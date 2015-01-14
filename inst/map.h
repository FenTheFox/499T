//
//  map.h
//  inst
//
//  Created by Timm Allman on 1/10/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#ifndef __inst__map__
#define __inst__map__

#define ARR_SIZE 1000
#define LIST_SIZE 100

#include <cstdlib>

struct pair {
	size_t first;
	size_t second;
};

class map {
	pair values [ARR_SIZE][LIST_SIZE];
	bool inUse [ARR_SIZE][LIST_SIZE];
public:
	size_t at(size_t);
	void erase(size_t);
	void insert(size_t, size_t);
};

#endif /* defined(__inst__map__) */
