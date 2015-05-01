#include "timer.h"
#include "speedtest.h"

#ifdef REPLACE_MALLOC
#ifndef MMAP_SIZE
#define MMAP_SIZE 16777216
#endif
void *mmapPtr;
#endif

using namespace std;

// Global Variables
vector<timer> timers;
mutex timer_mux, stmt_count, io_mux, err_mux;

int checkErr(int err, int line, sqlite3 *db, string extra) {
	lock_guard<mutex> lock(err_mux);
	switch (err) {
		case SQLITE_OK:
		case SQLITE_ROW:
		case SQLITE_DONE:
			break;
		case SQLITE_CONSTRAINT:
			cerr << "At " << __FILE__ << " " << line << ": " << sqlite3_errstr(err) << "(" << err << ")" << endl;
			cerr << sqlite3_errmsg(db) << endl;
			cerr << extra << endl;
			break;
		case SQLITE_NOMEM:
			cerr << line << " mem highwater: " << sqlite3_memory_highwater(false) << endl;
			break;
		default:
			cerr << "At " << __FILE__ << " " << line << ": " << sqlite3_errstr(err) << "(" << err << ")" << endl;
			cerr << sqlite3_errmsg(db) << endl;
			cerr << extra << endl;
			exit(1);
	};

	return err;
}

/**
 * Prepare and runTimer a single statement of SQL.
 */
void prepareAndRun(sqlite3 *db, string stmt, timer &t) {
	sqlite3_stmt *pStmt;

	t.start();
	checkErr(sqlite3_prepare_v2(db, stmt.c_str(), -1, &pStmt, NULL), __LINE__, db, stmt);
	while (checkErr(sqlite3_step(pStmt), __LINE__, db, stmt) == SQLITE_ROW);
	checkErr(sqlite3_finalize(pStmt), __LINE__, db, stmt);
	t.end();
}

/**
 * run all of the statements in a file
 */
timer runScriptFile(sqlite3 *db, char *fname, int idx) {
	ifstream script(fname);
	return runScriptFile(db,script,idx);
}

/**
 * run all of the statements in a file
 */
timer runScriptFile(sqlite3 *db, ifstream &script, int idx) {
	string stmt;
	timer t;

	while (getline(script, stmt, ';')) {
		// Hit EOF or error
		if (!script.good()) break;

		stmt = trim(stmt, "\r\n \t");
		stmt.push_back(';');

		prepareAndRun(db, stmt, t);
	}
	return t;
}

/**
 * run a prepared statement on everything in a file
 */
timer runScriptFile(sqlite3 *db, sqlite3_stmt *pstmt, ifstream &input, int num, string type, int idx) {
	string param;
	timer t = timer();

	while (getline(input, param)) {
		// Hit EOF or error
		if (!input.good()) break;

		t.start();
		for (int i = 1; i <= num; i++)
			if(type.compare("int") == 0)
				checkErr(sqlite3_bind_int(pstmt, i, atoi(param.c_str())), __LINE__, db);
			else
				checkErr(sqlite3_bind_text(pstmt, i, param.c_str(), -1, NULL), __LINE__, db);

		while (sqlite3_step(pstmt) == SQLITE_ROW);
		checkErr(sqlite3_reset(pstmt), __LINE__, db);
		t.end();
	}

	t.start();
	checkErr(sqlite3_finalize(pstmt), __LINE__, db);
	t.end();

	return t;
}

void runThread(string fname, string dbfile, int idx) {
	sqlite3 *db;
	sqlite3_stmt *pstmt;
	string stmt, type;
	timer t;
	ifstream  f(fname);
	int num;

	if(!f.is_open())
		cerr << "Could not open " << fname << endl;

	checkErr(sqlite3_open_v2(dbfile.c_str(), &db, SQLITE_OPEN_READWRITE, NULL), __LINE__, db);

	getline(f, stmt);
	if((num = atoi(stmt.c_str())) > 0) {
		getline(f, type);
		getline(f, stmt, ';');
		f.ignore();
		stmt.push_back(';');
		t.start();
		checkErr(sqlite3_prepare_v2(db, stmt.c_str(), -1, &pstmt, NULL), __LINE__, db);
		t.end();
		t.merge(runScriptFile(db,pstmt,f,num,type,idx));
	} else {
		t.merge(runScriptFile(db,f,idx));
	}

	t.start();
	sqlite3_close_v2(db);
	t.end();
	lock_guard<mutex> lock(timer_mux);
	// cout << fname << " took " << t.dur().count() << endl;
	timers[idx].merge(t);
}

/**
 * Parses command line args and opens a database connection
 *	@Return list of sql scripts to execute
 */
list<string> setup(int argc, char *argv[], sqlite3 **db, string dbfile, int idx) {
	list<string> scripts;

	#ifdef REPLACE_MALLOC
	mmapPtr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	checkErr(sqlite3_config(SQLITE_CONFIG_HEAP, mmapPtr, MMAP_SIZE, 16), __LINE__);
	#endif

	checkErr(sqlite3_config(SQLITE_CONFIG_MULTITHREAD),__LINE__);
	checkErr(sqlite3_open_v2(dbfile.c_str(), db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, NULL), __LINE__, *db);

	if (argc >= 4 && strcmp(argv[1], "-s") == 0) {
		int n = atoi(argv[2]);
		argv += 2;
		argc -= 2;

// 		prepareAndRun(*db,"PRAGMA foreign_keys = OFF;",timers[idx]);
		for (int i = 1; i <= n; i++)
			timers[idx].merge(runScriptFile(*db, argv[i], idx));
// 		prepareAndRun(*db,"PRAGMA foreign_keys = ON;",timers[idx]);

		argv += n;
		argc -= n;
	} else if (argc < 2) {
		cerr << "Usage: " << argv[0] << " [-q] [-f <filename>] [-s <val>] sql-script ..." << endl
		     << "Runs the sql-scripts against a UTF8 database" << endl
		     << "options:" << endl
		     << "\t-q : only display summary results" << endl
		     << "\t-f <filename> : use filename as a database file. an in-memory database is used by default" << endl
		     << "\t-s n : use the first n scripts as the schema and initial seed data of the database. all other scripts are run in parallel" << endl;
		exit(1);
	}

	for (int i = 1; i < argc; i++)
		scripts.push_back(argv[i]);

	return scripts;
}

void test_main(int argc, char *argv[], int id) {
	timer::duration_type schema_time;
	sqlite3 *db;
	unique_lock<mutex> lock(io_mux,defer_lock);
	vector<thread> threads;

	string dbfile = "db";
	dbfile += to_string(id);

	list<string> scripts = setup(argc, argv, &db, dbfile, id);

	lock.lock();
	cout << "Schema:\t" << (schema_time = timers[id].dur()).count() << endl;
	lock.unlock();

	for (string fname : scripts)
		threads.emplace_back(runThread, fname, dbfile, id);

	for (size_t i = 0; i < threads.size(); i++)
		threads[i].join();

	lock.lock();
	cout << "Query:\t" << (timers[id].dur() - schema_time).count() << endl;
	lock.unlock();

	sqlite3_close(db);
	if(!(id%10))
		cerr << "mem highwater: " << sqlite3_memory_highwater(true) << endl;
	sqlite3_shutdown();
	#ifdef REPLACE_MALLOC
	munmap(mmapPtr, MMAP_SIZE);
	#endif
}

int main(int argc, char *argv[]) {
	int itrs = atoi(argv[1]);
	cout.precision(15);

	argc--;
	argv++;

	timers.resize(itrs);
	for(int i = 0; i < itrs; i++)
		test_main(argc,argv,i);

	return 0;
}