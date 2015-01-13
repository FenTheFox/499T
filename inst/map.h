//
//  map.h
//  inst
//
//  Created by Timm Allman on 1/10/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#ifndef __inst__map__
#define __inst__map__

#include <cstdlib>

struct pair {
	size_t first;
	size_t second;
};

class map {
	pair values [1000][100];
	bool inUse [1000][100];
public:
	size_t at(size_t);
	void erase(size_t);
	void insert(size_t, size_t);
};

#endif /* defined(__inst__map__) */
