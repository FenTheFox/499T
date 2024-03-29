cd ..
base=`pwd`

cd Malloc-Implementations/allocators/Hoard/src/
make linux-gcc-x86-64 linux-gcc-x86-64-log
cp libhoard* $base/Replace-Libs
make clean

cd ../../jemalloc
./autogen.sh
make build_lib_shared
cp lib/libjemalloc.so $base/Replace-Libs

./autogen.sh --with-jemalloc-prefix=replace_
make build_lib_shared
cp lib/libjemalloc.so $base/Replace-Libs/libjemalloc-rmalloc.so
make clean

cd ../nedmalloc
gcc -o $base/Replace-Libs/libnedmalloc.so -fstrict-aliasing -Wstrict-aliasing -Wall -Wno-unused -fargument-noalias -O3 -g -fPIC -fvisibility=hidden -fopenmp -DREPLACE_SYSTEM_ALLOCATOR -DUSE_ALLOCATOR=1 -DUSE_LOCKS=1 -DNEDMALLOCDEPRECATED= -DNDEBUG -DNEDMALLOC_DLL_EXPORTS nedmalloc.c -shared -lrt -lpthread
gcc -o $base/Replace-Libs/libnedmalloc-rmalloc.so -fstrict-aliasing -Wstrict-aliasing -Wall -Wno-unused -fargument-noalias -O3 -g -fPIC -fvisibility=hidden -fopenmp -DUSE_REPLACE_PREFIX -DUSE_ALLOCATOR=1 -DUSE_LOCKS=1 -DNEDMALLOCDEPRECATED= -DNDEBUG -DNEDMALLOC_DLL_EXPORTS nedmalloc.c -shared -lrt -lpthread

cd $base/source/firefox-release/
MOZCONFIG=.mozconfig-rmalloc ./mach build
cp ../firefox-bld-rmalloc/memory/replace/rmalloc/lib*.so $base/Replace-Libs

cd $base/Replace-Libs
nm *.so > nmlibs.txt