//
//  main.h
//  tmp
//
//  Created by Timm Allman on 9/26/14.
//  Copyright (c) 2014 UMass. All rights reserved.
//

#ifndef tmp_main_h
#define tmp_main_h

#include <fstream>
#include <iostream>
#include <list>
#include <mutex>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

#include <string.h>

#include <sys/times.h>
#include <sys/mman.h>

#include "sqlite3.h"

#include "time.h"
#include "stringops.h"

int checkErr(int err, int line, sqlite3 *db=NULL, string extra="");
void prepareAndRun(sqlite3 *db, string stmt, timer &t);
void runScriptFile(sqlite3 *db, string fname, int idx);
void runScriptFile(sqlite3 *db, ifstream &script, int idx);
void runScriptFile(sqlite3 *db, sqlite3_stmt *pstmt, ifstream &input, int num, string type, int idx);
void runThread(string fname, string dbfile, int idx);

#endif
