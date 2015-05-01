CC=gcc
CXX=g++
FLAGS=-g -Wall -I../inst
CFLAGS=$(FLAGS) -O3 -DSQLITE_TEMP_STORE=2 -DSQLITE_THREADSAFE=2
CFLAGS+= -DSQLITE_DEFAULT_FOREIGN_KEYS=1
CPPFLAGS=$(FLAGS) -std=c++11 -lpthread -ldl
OFILES=sqlite3.c sqlite3.h
OBJS=speedtest.cpp timer.h
LOG_OBJS=../inst/map.cpp ../inst/logger.cpp ../inst/rmmap.c
MEMFLAGS=-DREPLACE_MALLOC
MEM_MED=$(MEMFLAGS) -DMMAP_SIZE=50331648
MEM_LG=$(MEMFLAGS) -DMMAP_SIZE=268435456

all: sqlite3-sys\
	sqlite3-mem3-32 sqlite3-mem5-32 sqlite3-mem3log-32 sqlite3-mem5log-32\
	sqlite3-mem3-128 sqlite3-mem5-128 sqlite3-mem3log-128 sqlite3-mem5log-128

sqlite3-sys: sqlite3.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o $@ $^

sqlite3-mem3-32: sqlite3_mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_MED) -o $@ $^

sqlite3-mem3log-32: sqlite3_mem3log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_MED) -o $@ $^

sqlite3-mem3-128: sqlite3_mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_LG) -o $@ $^

sqlite3-mem3log-128: sqlite3_mem3log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_LG) -o $@ $^

sqlite3-mem5-32: sqlite3_mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_MED) -o $@ $^

sqlite3-mem5log-32: sqlite3_mem5log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_MED) -o $@ $^

sqlite3-mem5-128: sqlite3_mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_LG) -o $@ $^

sqlite3-mem5log-128: sqlite3_mem5log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEM_LG) -o $@ $^

sqlite3.o: $(OFILES)
	$(CC) -c $(CFLAGS) -o $@ $<

sqlite3_mem3.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS3 -o $@ $<

sqlite3_mem3log.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS3 -DINC_LOGGING -o $@ $<

sqlite3_mem5.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS5 -o $@ $<

sqlite3_mem5log.o: $(OFILES)
	$(CC) -c $(CFLAGS) -DSQLITE_ZERO_MALLOC -DSQLITE_ENABLE_MEMSYS5 -DINC_LOGGING -o $@ $<

clean:
	rm sqlite3-*
really_clean:
	rm *.o