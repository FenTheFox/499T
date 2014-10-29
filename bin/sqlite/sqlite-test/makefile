CXX=clang++
CPPFLAGS=-O3 -std=c++11
OBJS=speedtest.cpp time.h stringops.h
RMFLAGS=-DREPLACE_MALLOC

all: sqlite3-test sqlite3-zone-test sqlite3-mem3-test sqlite3-mem5-test

sqlite3-test: sqlite3.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o ../sqlite3-test sqlite3.o speedtest.cpp

sqlite3-zone-test: sqlite3-zone.o $(OBJS)
	$(CXX) $(CPPFLAGS) -o ../sqlite3-zone-test sqlite3-zone.o speedtest.cpp

sqlite3-mem3-test: sqlite3-mem3.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(RMFLAGS) -o ../sqlite3-mem3-test sqlite3-mem3.o speedtest.cpp

sqlite3-mem5-test: sqlite3-mem5.o $(OBJS)
	$(CXX) $(CPPFLAGS) $(RMFLAGS) -o ../sqlite3-mem5-test sqlite3-mem5.o speedtest.cpp

clean:
	rm ../sqlite3*