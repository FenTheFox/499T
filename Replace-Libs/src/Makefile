CXX=clang++
CPPFLAGS=-O3
LIBFLAGS=-dynamiclib $(CPPFLAGS)

# all: libslqite libfirefox
#
# libslqite: libsqlite.cpp
# 	$(CXX) libsqlite.cpp -o libsqlite.dylib $(CPPFLAGS)
#
# libfirefox: libfirefox.cpp
# 	$(CXX) libfirefox.cpp -o libfirefox.dylib $(CPPFLAGS)

replacemalloc: replacemalloc.cpp
	$(CXX) replacemalloc.cpp -o replacemalloc.dylib $(LIBFLAGS)
	
clean:
	rm *.dylib