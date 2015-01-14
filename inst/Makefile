CXX=clang++
CPPFLAGS=-g -std=c++11
LIBFLAGS=-shared -dynamiclib $(CPPFLAGS)
OBJS=main.cpp logger.cpp map.cpp

test-dbug: $(OBJS)
	$(CXX) -o test $(CPPFLAGS) $^

test: $(OBJS)
	$(CXX) -o test -O3 $(CPPFLAGS) $^
	
clean:
	rm test