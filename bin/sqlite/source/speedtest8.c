/*
** Performance test for SQLite.
**
** This program reads ASCII text from a file named on the command-line
** and submits that text  to SQLite for evaluation.  A new database
** is created at the beginning of the program.  All statements are
** timed using the high-resolution timer built into Intel-class processors.
**
** To compile this program, first compile the SQLite library separately
** will full optimizations.  For example:
**
**     gcc -c -O6 -DSQLITE_THREADSAFE=0 sqlite3.c
**
** Then link against this program.  But to do optimize this program
** because that defeats the hi-res timer.
**
**     gcc speedtest8.c sqlite3.o -ldl -I../src
**
** Then run this program with a single argument which is the name of
** a file containing SQL script that you want to test:
**
**     ./a.out test.db  test.sql
*/
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <time.h>
#include <unistd.h>
#include <sys/times.h>
#include <sched.h>

#include "sqlite3.h"

/*
** Timers
*/
static uint64_t prepTime = 0;
static uint64_t runTime = 0;
static uint64_t finalizeTime = 0;

/*
** Prepare and run a single statement of SQL.
*/
static void prepareAndRun(sqlite3 *db, const char *zSql, int bQuiet){
  sqlite3_stmt *pStmt;
  const char *stmtTail;
  uint64_t iStart, iElapse;
  int rc;

  if (!bQuiet){
    printf("***************************************************************\n");
    printf("SQL statement: [%s]\n", zSql);
  }

  iStart = hwtime();
  rc = sqlite3_prepare_v2(db, zSql, -1, &pStmt, &stmtTail);
  iElapse = hwtime() - iStart;
  prepTime += iElapse;

  if (!bQuiet)
    printf("sqlite3_prepare_v2() returns %d in %llu cycles\n", rc, iElapse);

  if( rc==SQLITE_OK ){
    int nRow = 0;
    iStart = hwtime();
    while( (rc=sqlite3_step(pStmt))==SQLITE_ROW ){ nRow++; }
    iElapse = hwtime() - iStart;
    runTime += iElapse;

    if (!bQuiet)
      printf("sqlite3_step() returns %d after %d rows in %llu cycles\n", rc, nRow, iElapse);

    iStart = hwtime();
    rc = sqlite3_finalize(pStmt);
    iElapse = hwtime() - iStart;
    finalizeTime += iElapse;

    if (!bQuiet)
      printf("sqlite3_finalize() returns %d in %llu cycles\n", rc, iElapse);
  }
}

int main(int argc, char **argv){
  sqlite3 *db;
  int rc;
  int nSql;
  char *zSql;
  int i, j;
  FILE *in;
  uint64_t iStart, iElapse;
  uint64_t iSetup = 0;
  int nStmt = 0;
  int nByte = 0;
  const char *zArgv0 = argv[0];
  int bQuiet = 0;
  struct tms tmsStart, tmsEnd;
  clock_t clkStart, clkEnd;

  while (argc>3)
  {
    /*
    ** Increasing the priority slightly above normal can help with
    ** repeatability of testing.  Note that with Cygwin, -5 equates
    ** to "High", +5 equates to "Low", and anything in between
    ** equates to "Normal".
    */
    if( argc > 4 && (strcmp(argv[1], "-priority") == 0) ){
      int setPrio = atoi(argv[2]);
      printf ("Current process priority is %d.\n", getpriority(PRIO_PROCESS, 0));
      printf ("Setting process priority to %d.\n", setPrio);
      if (setpriority(PRIO_PROCESS, 0, setPrio) != 0){
        printf ("error setting priority\n");
        exit(2);
      }
      argv += 2;
      argc -= 2;
      continue;
    }

    if( argc > 3 && strcmp(argv[1], "-quiet") == 0 ){
     bQuiet = -1;
     argv++;
     argc--;
     continue;
    }

    break;
  }

  if( argc != 3 ){
   fprintf(stderr, "Usage: %s [options] FILENAME SQL-SCRIPT\n"
              "Runs SQL-SCRIPT against a UTF8 database\n"
              "\toptions:\n"
              "\t-priority <value> : set priority of task\n"
              "\t-quiet : only display summary results\n",
              zArgv0);
   exit(1);
  }

  in = fopen(argv[2], "r");
  fseek(in, 0L, SEEK_END);
  nSql = ftell(in);
  zSql = malloc( nSql+1 );
  fseek(in, 0L, SEEK_SET);
  nSql = fread(zSql, 1, nSql, in);
  zSql[nSql] = 0;

  printf("SQLite version: %d\n", sqlite3_libversion_number());
  unlink(argv[1]);
  clkStart = times(&tmsStart);
  iStart = hwtime();
  rc = sqlite3_open(argv[1], &db);
  iElapse = hwtime() - iStart;
  iSetup = iElapse;

  if (!bQuiet)
    printf("sqlite3_open() returns %d in %llu cycles\n", rc, iElapse);

  for(i=j=0; j<nSql; j++){
    if( zSql[j]==';' ){
      int isComplete;
      char c = zSql[j+1];
      zSql[j+1] = 0;
      isComplete = sqlite3_complete(&zSql[i]);
      zSql[j+1] = c;
      if( isComplete ){
        zSql[j] = 0;
        while( i<j && isspace(zSql[i]) ){ i++; }
        if( i<j ){
          int n = j - i;
          if( n>=6 && memcmp(&zSql[i], ".crash",6)==0 ) exit(1);
          nStmt++;
          nByte += n;
          prepareAndRun(db, &zSql[i], bQuiet);
        }
        zSql[j] = ';';
        i = j+1;
      }
    }
  }
  iStart = hwtime();
  sqlite3_close(db);
  iElapse = hwtime() - iStart;
  clkEnd = times(&tmsEnd);
  iSetup += iElapse;

  if (!bQuiet)
    printf("sqlite3_close() returns in %llu cycles\n", iElapse);

  printf("\n");
  printf("Statements run:        %15d stmts\n", nStmt);
  printf("Bytes of SQL text:     %15d bytes\n", nByte);
  printf("Total prepare time:    %15llu cycles\n", prepTime);
  printf("Total run time:        %15llu cycles\n", runTime);
  printf("Total finalize time:   %15llu cycles\n", finalizeTime);
  printf("Open/Close time:       %15llu cycles\n", iSetup);
  printf("Total time:            %15llu cycles\n",
      prepTime + runTime + finalizeTime + iSetup);

  printf("\n");
  printf("Total user CPU time:   %15.3g secs\n", (tmsEnd.tms_utime - tmsStart.tms_utime)/(double)CLOCKS_PER_SEC );
  printf("Total system CPU time: %15.3g secs\n", (tmsEnd.tms_stime - tmsStart.tms_stime)/(double)CLOCKS_PER_SEC );
  printf("Total real time:       %15.3g secs\n", (clkEnd -clkStart)/(double)CLOCKS_PER_SEC );

  return 0;
}