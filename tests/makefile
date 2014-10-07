CXX=clang++
CPPFLAGS=-I../Replace-Libs/src -Wl,-flat_namespace,-undefined,dynamic_lookup
CC=clang
CFLAGS=

all: example cexample lib

example: example.cpp
	$(CXX) -o example example.cpp $(CPPFLAGS)

cexample: example.c
	$(CC) -o cexample example.c
	
lib: lib_overrides.cpp
	$(CXX) -dynamiclib lib_overrides.cpp -o lib_overrides.dylib

clean:
	rm example example.txt cexample lib_overrides.dylib