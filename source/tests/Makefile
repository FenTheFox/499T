CC=gcc
CXX=g++
CFLAGS=-g
CPPFLAGS=-g -std=c++11
LIBFLAGS=-shared $(CPPFLAGS)
OBJS=main.cpp logger.cpp map.cpp

all: test test-dbug

test-dbug: $(OBJS)
	$(CXX) -o $@ $(CPPFLAGS) $^

test: $(OBJS)
	$(CXX) -o $@ -O3 $(CPPFLAGS) $^

clean:
	rm test*