//
//  stringops.h
//  sqlite-test
//
//  Created by Timm Allman on 10/22/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#include <iostream>
#include <string>

#ifndef sqlite_test_stringops_h
#define sqlite_test_stringops_h

std::string trim(std::string str, std::string whitespace = " \t")
{
	auto strBegin = str.find_first_not_of(whitespace);
	if (strBegin == std::string::npos)
		return ""; // no content

	auto strEnd = str.find_last_not_of(whitespace);
	auto strRange = strEnd - strBegin + 1;

	return str.substr(strBegin, strRange);
}

#endif