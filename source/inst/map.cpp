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

void lmap::init() {
	for (int i = 0; i < ARR_SIZE; ++i)
		for (int j = 0; j < LIST_SIZE; ++j)
			values[i][j] = pair_t();
}

size_t lmap::at(size_t k) {
	size_t hval = k % ARR_SIZE;
	pair_t p = pair_t();

	for (int i = 0; i < LIST_SIZE; i++) {
		p = values[hval][i];
		if (p.first == k && p.active)
			break;
	}

	return p.second;
}

void lmap::erase(size_t k) {
	size_t hval = k % ARR_SIZE;
	pair_t p;
	for (int i = 0; i < LIST_SIZE; i++) {
		p = values[hval][i];
		if (values[hval][i].first == k && values[hval][i].active) {
			values[hval][i].active = false;
			break;
		}
	}
}

void lmap::insert(size_t k, size_t v) {
	size_t hval = k % ARR_SIZE;
	pair_t p;
	p.first = k;
	p.second = v;
	p.active = true;
	bool flag = false;

	for (int i = 0; i < LIST_SIZE; i++) {
		if (!values[hval][i].active) {
			values[hval][i] = p;
			flag = true;
			break;
		}
	}

	if (!flag)
		write(1, "inc map size\n", 13);
}