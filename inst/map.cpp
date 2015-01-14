//
//  map.cpp
//  inst
//
//  Created by Timm Allman on 1/10/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include <unistd.h>

#include "map.h"

size_t map::at(size_t k) {
	size_t hval = k % ARR_SIZE;
	pair p = pair();
	bool flag = false;

	for (int i = 0; i < LIST_SIZE; i++) {
		if (values[hval][i].first == k && inUse[hval][i]) {
			p = values[hval][i];
			flag = true;
			break;
		}
	}
	if (!flag)
		write(1, "not found\n", 10);

	return p.second;
}

void map::erase(size_t k) {
	size_t hval = k % ARR_SIZE;
	for (int i = 0; i < LIST_SIZE; i++) {
		if (values[hval][i].first == k && inUse[hval][i]) {
			inUse[hval][i] = false;
			break;
		}
	}
}

void map::insert(size_t k, size_t v) {
	size_t hval = k % ARR_SIZE;
	pair p;
	p.first = k;
	p.second = v;
	bool flag = false;

	for (int i = 0; i < LIST_SIZE; i++) {
		if (!inUse[hval][i]) {
			values[hval][i] = p;
			inUse[hval][i] = true;
			flag = true;
			break;
		}
	}

	if (!flag)
		write(1, "inc map size\n", 14);
}