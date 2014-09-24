CXX=clang++
CPPFLAGS=
CC=clang
CFLAGS=

all: example cexample lib

example: example.cpp
	$(CXX) -o example example.cpp

cexample: example.c
	$(CC) -o cexample example.c
	
lib: lib_overrides.cpp
	$(CC) -dynamiclib lib_overrides.cpp -o lib_overrides.dylib

clean:
	rm example example.txt cexample logmalloc.dylib