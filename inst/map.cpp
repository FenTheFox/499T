//
//  map.cpp
//  inst
//
//  Created by Timm Allman on 1/10/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include "map.h"

size_t map::at(size_t k) {
	size_t hval = k % 1000;
	pair p = pair();

	for (int i = 0; i < 100; i++) {
		if (values[hval][i].first == k && inUse[hval][i]) {
			p = values[hval][i];
			break;
		}
	}
	return p.second;
}

void map::erase(size_t k) {
	size_t hval = k % 1000;
	for (int i = 0; i < 100; i++) {
		if (values[hval][i].first == k && inUse[hval][i]) {
			inUse[hval][i] = false;
			break;
		}
	}
}

void map::insert(size_t k, size_t v) {
	size_t hval = k % 1000;
	pair p;
	p.first = k;
	p.second = v;

	for (int i = 0; i < 100; i++) {
		if (!inUse[hval][i]) {
			values[hval][i] = p;
			inUse[hval][i] = true;
			break;
		}
	}
}
