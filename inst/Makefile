CXX=clang++
CPPFLAGS=-O3
LIBFLAGS=-shared -Wl,-undefined,dynamic_lookup -dynamiclib $(CPPFLAGS)

rmmap: rmmap.c
	clang rmmap.c -o ../rmmap.dylib $(LIBFLAGS)
	
clean:
	rm ../Replace-Libs/rmmap.dylib