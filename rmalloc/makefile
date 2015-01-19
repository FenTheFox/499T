CC=clang
CXX=clang++
CFLAGS=-g -O3 -dynamiclib -Wl,-flat_namespace,-undefined,dynamic_lookup
INC=-I. -I../source/firefox-bld-rmalloc/dist/include -include ../source/firefox-bld/dist/include/mozilla-config.h

all: rmalloc rmalloc-log

rmalloc: replacemallocfirefox.c
	$(CC) $(CFLAGS) $(INC) -o ../Replace-Libs/librmalloc.dylib $^
	
rmalloc-log: replacemallocfirefox-log.c logger.o map.o rmmap.o
	$(CC) $(CFLAGS) $(INC) -o ../Replace-Libs/librmalloc-log.dylib $^
	
logger.o: logger.cpp
	$(CXX) -g -O3 -c $^
map.o: map.cpp
	$(CXX) -g -O3 -c $^
rmmap.o: rmmap.cpp
	$(CXX) -g -O3 -c $^