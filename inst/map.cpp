//
//  map.cpp
//  inst
//
//  Created by Timm Allman on 1/10/15.
//  Copyright (c) 2015 UMass. All rights reserved.
//

#include <stdio.h>
#include <unistd.h>

int strlen(char *str, int len)
{
	for (int i = 0; i < len; i++)
		if (str[i] == '\0')
			len = i;
	return len;
}

#include "map.h"

size_t lmap::at(size_t k) {
	size_t hval = k % ARR_SIZE;
	pair_t p = pair_t();
	bool flag = false;

	for (int i = 0; i < LIST_SIZE; i++) {
		if (values[hval][i].first == k && inUse[hval][i]) {
			p = values[hval][i];
			flag = true;
			break;
		}
	}
	if (!flag) {
		char str[31];
		sprintf(str, "%zu not found\n", k);
		write(1, str, strlen(str, 31));
	}

	return p.second;
}

void lmap::erase(size_t k) {
	size_t hval = k % ARR_SIZE;
	for (int i = 0; i < LIST_SIZE; i++) {
		if (values[hval][i].first == k && inUse[hval][i]) {
			inUse[hval][i] = false;
			break;
		}
	}
}

void lmap::insert(size_t k, size_t v) {
	size_t hval = k % ARR_SIZE;
	pair_t p;
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