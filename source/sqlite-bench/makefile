CC=gcc
CXX=g++
FLAGS=-g -O3 -Wall -I../inst
# FLAGS=-g -Wall -I../inst
# CFLAGS=$(FLAGS) -DSQLITE_TEMP_STORE=2 -DSQLITE_THREADSAFE=2 -DSQLITE_DEFAULT_FOREIGN_KEYS=1
CFLAGS=$(FLAGS) -DSQLITE_TEMP_STORE=2 -DSQLITE_THREADSAFE=2
CPPFLAGS=$(FLAGS) -std=c++11 -lpthread -ldl
OFILES=sqlite3.c sqlite3.h
OBJS=speedtest.cpp
LOG_OBJS=../inst/map.cpp ../inst/logger.cpp ../inst/rmmap.c
MEMFLAGS=-DREPLACE_MALLOC
MEM128kb=$(MEMFLAGS) -DMMAP_SIZE=131072 -DLOGGER_SAMPLES=999
MEM128mb=$(MEMFLAGS) -DMMAP_SIZE=137438953472

all: sqlite3-sys\
	sqlite3-mem3-128kb sqlite3-mem5-128kb sqlite3-mem3log-128kb sqlite3-mem5log-128kb\
	sqlite3-mem3-1mb sqlite3-mem5-1mb sqlite3-mem3log-1mb sqlite3-mem5log-1mb\
	sqlite3-mem3-128mb sqlite3-mem5-128mb sqlite3-mem3log-128mb sqlite3-mem5log-128mb

sqlite3-sys: sqlite3.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o $@ $^

sqlite3-mem3-128kb: sqlite3-mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128kb) -o $@ $^

sqlite3-mem3log-128kb: sqlite3-mem3log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128kb) -o $@ $^

sqlite3-mem3-1mb: sqlite3-mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o $@ $^

sqlite3-mem3log-1mb: sqlite3-mem3log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o $@ $^

sqlite3-mem3-128mb: sqlite3-mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128mb) -o $@ $^

sqlite3-mem3log-128mb: sqlite3-mem3log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128mb) -o $@ $^

sqlite3-mem5-128kb: sqlite3-mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128kb) -o $@ $^

sqlite3-mem5log-128kb: sqlite3-mem5log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128kb) -o $@ $^

sqlite3-mem5-1mb: sqlite3-mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o $@ $^

sqlite3-mem5log-1mb: sqlite3-mem5log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o $@ $^

sqlite3-mem5-128mb: sqlite3-mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128mb) -o $@ $^

sqlite3-mem5log-128mb: sqlite3-mem5log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM128mb) -o $@ $^

sqlite3.o: $(OFILES)
	$(CC) -c $(CFLAGS) -o $@ $<

sqlite3-mem3.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS3 -o $@ $<

sqlite3-mem3log.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS3 -DINC_LOGGING -o $@ $<

sqlite3-mem5.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS5 -o $@ $<

sqlite3-mem5log.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS5 -DINC_LOGGING -o $@ $<

clean:
	rm sqlite3.o sqlite3-*