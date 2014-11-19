#include "time.h"
#include "stringops.h"

#include "speedtest.h"

#define MMAP_SIZE 33554432

using namespace std;

// Global Variables
timer setupTimer, prepTimer, runTimer, finalizeTimer;

mutex timers, stmt_count;

bool quiet;

int stmts = 0;

/**
 * Prepare and runTimer a single statement of SQL.
 */
void prepareAndRun(sqlite3 *db, string stmt) {
	sqlite3_stmt *pStmt;
	int rc;

	timer p = timer(), r = timer(), f = timer();

	if (!quiet)
		cout << "***************************************************************" << endl
		     << "SQL statement: ["
		     << stmt
		     << "]" << endl;

	p.start();
	rc = sqlite3_prepare_v2(db, stmt.c_str(), -1, &pStmt, NULL);
	p.end();

	if (rc == SQLITE_OK) {
		int nRow = 0;

		r.start();
		while ((rc = sqlite3_step(pStmt)) == SQLITE_ROW)
			nRow++;
		r.end();

		f.start();
		rc = sqlite3_finalize(pStmt);
		f.end();
	}

	lock_guard<mutex> lock(timers);
	prepTimer.merge(p);
	runTimer.merge(r);
	finalizeTimer.merge(f);
}

/**
 * runTimer all of the statements in a file
 */
void runScriptFile(sqlite3 *db, string name) {
	ifstream script;
	string stmt;

	script.open(name);

	if (!quiet)
		cout << name << endl;

	while (true) {
		getline(script, stmt, ';');

		stmt = trim(stmt, "\n \t");

		// Hit EOF or error
		if (!script.good())
			break;

		stmt.push_back(';');

		if (!(sqlite3_complete(stmt.c_str())))
			continue;

//		unique_lock<mutex> lock(stmt_count);
		stmts++;
//		unique_lock<mutex> unlock(stmt_count);

		prepareAndRun(db, stmt);
	}
}

/**
 * Parses command line args and opens a database connection
 *	@Return list of sql scripts to execute
 */
list<string> setup(int argc, char *argv[], sqlite3 **db) {
	int rc;

	string dbfile = ":memory:";
	list<string> scripts;

	if (argc >= 2 && strcmp(argv[1], "-q") == 0) {
		quiet = true;
		argv++;
		argc--;
	} else {
		quiet = false;
	}

	if (argc >= 4 && strcmp(argv[1], "-f") == 0) {
		if (!quiet)
			cout << "Using " << argv[2] << " as a database file" << endl;

		dbfile = argv[2];
		argv += 2;
		argc -= 2;
	}

	setupTimer.start();

#ifdef REPLACE_MALLOC
	void *ptr = mmap(NULL, MMAP_SIZE, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANON, -1, 0);
	rc = sqlite3_config(SQLITE_CONFIG_HEAP, ptr, MMAP_SIZE, 8);

	if (!quiet)
		cout << "sqlite3_config() returned " << rc << endl;
#endif

	rc = sqlite3_open_v2(dbfile.c_str(), db, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE, NULL);
	setupTimer.end();

	if (!quiet)
		printf("sqlite3_open_v2() returns %d in %f ns\n", rc, setupTimer.duration());

	if (argc >= 4 && strcmp(argv[1], "-s") == 0) {
		int n = atoi(argv[2]);
		argv += 2;
		argc -= 2;

		for (int i = 1; i <= n; i++)
			runScriptFile(*db, argv[i]);

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

	if (!quiet)
		cout << "Sqlite version: " << sqlite3_libversion_number() << endl;

	for (int i = 1; i < argc; i++)
		scripts.push_back(argv[i]);

	return scripts;
}

double test_main(int argc, char *argv[]) {
	struct tms tmsStart, tmsEnd;
	clock_t clkStart, clkEnd;

	sqlite3 *db;

	list<string> scripts = setup(argc, argv, &db);
	vector<thread> threads = vector<thread>();

	clkStart = times(&tmsStart);

	for (string fname : scripts)
		threads.emplace_back(runScriptFile, db, fname);

	for (int i = 0; i < threads.size(); i++)
		threads[i].join();

	setupTimer.start();
	sqlite3_close(db);
	setupTimer.end();
	clkEnd = times(&tmsEnd);

	if (!quiet)
		cout << "sqlite3_close() returns in " << setupTimer.duration() << " ns" << endl;

//	cout << endl;
//	printf("Statements run:      %d ish stmts\n", stmts);
//	printf("Total prepare time:  %f ns\n", prepTimer.total_duration());
//	printf("Total run time:      %f ns\n", runTimer.total_duration());
//	printf("Total finalize time: %f ns\n", finalizeTimer.total_duration());
//	printf("Open/Close time:     %f ns\n", setupTimer.total_duration());
	printf("Total time:          %f ns\n", prepTimer.total_duration() + runTimer.total_duration() +
	                                             finalizeTimer.total_duration() + setupTimer.total_duration());
	
//	cout << endl;
//	printf("Total user CPU time:   %15.3g secs\n", (tmsEnd.tms_utime - tmsStart.tms_utime) / (double)CLOCKS_PER_SEC);
//	printf("Total system CPU time: %15.3g secs\n", (tmsEnd.tms_stime - tmsStart.tms_stime) / (double)CLOCKS_PER_SEC);
//	printf("Total real time:	   %15.3g secs\n", (clkEnd - clkStart) / (double)CLOCKS_PER_SEC);

	return prepTimer.total_duration() + runTimer.total_duration() + finalizeTimer.total_duration() + setupTimer.total_duration();
}

int main(int argc, char *argv[]) {
	int itrs = atoi(argv[1]);
	double time;

	argc--;
	argv++;

	for(int i = 0; i < itrs; i++) {
		setupTimer = timer();
		prepTimer = timer();
		runTimer = timer();
		finalizeTimer = timer();

		time += test_main(argc, argv);
	}

	printf("Average: %f\n", time/itrs);

	return 0;
}