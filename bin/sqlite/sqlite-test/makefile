CXX=clang++
CPPFLAGS=-O3 -g -std=c++11
OBJS=speedtest.cpp time.h stringops.h
LOG_OBJS=map.o logger.o rmmap.o
MEMFLAGS=-DREPLACE_MALLOC

all: sqlite3-sys sqlite3-zone sqlite3-rmalloc sqlite3-rmalloc-zone sqlite3-mem3 sqlite3-mem3log sqlite3-mem5 sqlite3-mem5log

sqlite3-sys: sqlite3.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o ../sqlite3-sys sqlite3.o speedtest.cpp

sqlite3-zone: sqlite3-zone.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o ../sqlite3-zone sqlite3-zone.o speedtest.cpp
	
sqlite3-rmalloc: sqlite3-rmalloc.o $(OBJS)
	$(CXX) $(CPPFLAGS) -Wl,-undefined,dynamic_lookup -o ../sqlite3-rmalloc sqlite3-rmalloc.o speedtest.cpp

sqlite3-rmalloc-zone: sqlite3-rmalloczone.o $(OBJS)
	$(CXX) $(CPPFLAGS) -Wl,-undefined,dynamic_lookup -o ../sqlite3-rmalloc-zone sqlite3-rmalloczone.o speedtest.cpp

sqlite3-mem3: sqlite3-mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem3 sqlite3-mem3.o speedtest.cpp
	
sqlite3-mem3log: sqlite3-mem3log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem3log sqlite3-mem3log.o $(LOG_OBJS) speedtest.cpp

sqlite3-mem5: sqlite3-mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem5 sqlite3-mem5.o speedtest.cpp
	
sqlite3-mem5log: sqlite3-mem5log.o $(OBJS) $(LOG_OBJS)
	$(CXX) $(CPPFLAGS) $(MEMFLAGS) -o ../sqlite3-mem5log sqlite3-mem5log.o $(LOG_OBJS) speedtest.cpp

clean:
	rm ../sqlite3*