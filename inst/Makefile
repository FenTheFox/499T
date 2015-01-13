CXX=clang++
CPPFLAGS=-O3 -std=c++11
LIBFLAGS=-shared -dynamiclib $(CPPFLAGS)
OBJS=rmmap.cpp logger.cpp map.cpp
	
test: main.cpp
	$(CXX) -o test $(CPPFLAGS) $^
	
clean:
	rm test