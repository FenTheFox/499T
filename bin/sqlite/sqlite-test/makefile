CC=gcc
CXX=g++
CFLAGS=-g -O3 -DSQLITE_TEMP_STORE=2 -DSQLITE_THREADSAFE=2
CPPFLAGS=-g -std=c++11 -lpthread -ldl
OFILES=sqlite3.c sqlite3.h
OBJS=speedtest.cpp
LOG_OBJS=map.cpp logger.cpp rmmap.c
MEMFLAGS=-DREPLACE_MALLOC

all: sqlite3-sys sqlite3-rmalloc sqlite3-mem3 sqlite3-mem3log sqlite3-mem5 sqlite3-mem5log

sqlite3-sys: sqlite3.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o ../sqlite3-sys $^
	
sqlite3-rmalloc: sqlite3-rmalloc.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o ../sqlite3-rmalloc $^

sqlite3-mem3: sqlite3-mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem3 $^
	
sqlite3-mem3log: sqlite3-mem3log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem3log $^

sqlite3-mem5: sqlite3-mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem5 $^
	
sqlite3-mem5log: sqlite3-mem5log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem5log $^

sqlite3.o: $(OFILES)
	$(CC) -c $(CFLAGS) -o $@ $<

sqlite3-rmalloc.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DREPLACE_MALLOC -o $@ $<

sqlite3-mem3.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS3 -o $@ $<

sqlite3-mem3log.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS3 -DINC_LOGGING -o $@ $<

sqlite3-mem5.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS5 -o $@ $<

sqlite3-mem5log.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS5 -DINC_LOGGING -o $@ $<

clean:
	rm ../sqlite3* *.o