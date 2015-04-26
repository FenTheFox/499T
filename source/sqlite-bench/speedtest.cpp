#include "time.h"
#include "stringops.h"

#include "speedtest.h"

#ifdef REPLACE_MALLOC
#ifndef MMAP_SIZE
	#define MMAP_SIZE 1048576
#endif
void *mmapPtr;
#endif

using namespace std;

// Global Variables
auto timers = vector<timer>();
mutex timer_mux, stmt_count, io_mux, err_mux;

void checkErr(int err, int line, sqlite3 *db=NULL, string extra="") {
	if(err == SQLITE_OK || err == SQLITE_ROW || err == SQLITE_DONE) return;

	lock_guard<mutex> lock(err_mux);
	cerr << "At " << __FILE__ << " " << line << ": " << sqlite3_errstr(err) << endl;
	cerr << sqlite3_errmsg(db) << endl;
	cerr << extra << endl;
	exit(1);
}

/**
 * Prepare and runTimer a single statement of SQL.
 */
void prepareAndRun(sqlite3 *db, string stmt, timer &t) {
	sqlite3_stmt *pStmt;

	t.start();
	checkErr(sqlite3_prepare_v2(db, stmt.c_str(), -1, &pStmt, NULL), __LINE__, db);
	while (sqlite3_step(pStmt) == SQLITE_ROW);
	checkErr(sqlite3_finalize(pStmt), __LINE__, db, stmt);
	t.end();
}

/**
 * run all of the statements in a file
 */
void runScriptFile(sqlite3 *db, string name, int idx) {
	ifstream script (name);
	string stmt;
	timer t = timer();

	while (getline(script, stmt, ';')) {
		// Hit EOF or error
		if (!script.good()) break;

		stmt = trim(stmt, "\r\n \t");
		stmt.push_back(';');

		if (sqlite3_complete(stmt.c_str()))
			prepareAndRun(db, stmt, t);
	}
	lock_guard<mutex> lock(timer_mux);
	timers[idx].merge(t);
}

/**
 * run a prepared statement on evertyhing in a file
 */
void runScriptFile(sqlite3 *db, sqlite3_stmt *pstmt, ifstream &input, int num, string type, int idx) {
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

	lock_guard<mutex> lock(timer_mux);
	timers[idx].merge(t);
}

void runThread(string fname, string dbfile, int idx) {
	sqlite3 *db;
	sqlite3_stmt *pstmt;
	string stmt, type;
	timer t = timer();
	ifstream  f(fname);
	int num;

	getline(f, stmt);
	num = atoi(stmt.c_str());
	getline(f, type);
	getline(f, stmt, ';');
	f.ignore();
	stmt.push_back(';');

	checkErr(sqlite3_open_v2(dbfile.c_str(), &db, SQLITE_OPEN_READWRITE, NULL), __LINE__, db);
	t.start();
	checkErr(sqlite3_prepare_v2(db, stmt.c_str(), -1, &pstmt, NULL), __LINE__, db);
	t.end();

	runScriptFile(db,pstmt,f,num,type,idx);

	t.start();
	sqlite3_close_v2(db);
	t.end();
	lock_guard<mutex> lock(timer_mux);
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
	checkErr(sqlite3_config(SQLITE_CONFIG_HEAP, mmapPtr, MMAP_SIZE, 32), __LINE__);
	#endif

	checkErr(sqlite3_config(SQLITE_CONFIG_MULTITHREAD),__LINE__);
	checkErr(sqlite3_config(SQLITE_CONFIG_URI, 1),__LINE__);
	checkErr(sqlite3_open_v2(dbfile.c_str(), db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, NULL), __LINE__, *db);

	if (argc >= 4 && strcmp(argv[1], "-s") == 0) {
		int n = atoi(argv[2]);
		argv += 2;
		argc -= 2;

		for (int i = 1; i <= n; i++)
			runScriptFile(*db, argv[i], idx);

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

double test_main(int argc, char *argv[], int id) {
	double schema_time, query_time;
	sqlite3 *db;
	unique_lock<mutex> lock(io_mux,defer_lock);
	auto threads = vector<thread>();

	string dbfile = "file:db";
	dbfile += to_string(id);

	list<string> scripts = setup(argc, argv, &db, dbfile, id);

	schema_time = timers[id].total_duration();
	lock.lock();
	cout << "Schema:\t" << schema_time << endl;
	lock.unlock();

	for (string fname : scripts)
		threads.emplace_back(runThread, fname, dbfile, id);

	for (size_t i = 0; i < threads.size(); i++)
		threads[i].join();

	query_time = timers[id].total_duration() - schema_time;
	lock.lock();
	cout << "Query:\t" << query_time << endl;
	lock.unlock();

	sqlite3_close(db);

	sqlite3_shutdown();
	#ifdef REPLACE_MALLOC
	munmap(mmapPtr, MMAP_SIZE);
	#endif

	return timers[id].total_duration();
}

int main(int argc, char *argv[]) {
	int itrs = atoi(argv[1]);
	auto threads = vector<thread>();
	string dbfile;
	cout.precision(15);

	argc--;
	argv++;

	for(int i = 0; i < itrs; i++) {
		timers.push_back(timer());
		test_main(argc,argv,i);
	}

	return 0;
}