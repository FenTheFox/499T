#!/usr/bin/zsh

integer logfd
integer glogfd
glogf=logs/render.log
exec {glogfd} >> ${glogf}
exec >&${glogfd} 2>&1

echo 'php -S localhost:8000 -t renderbench -c php.ini &' >&0
php -S localhost:8000 -t renderbench -c php.ini &

logf=logs/flog-bld.log
exec {logfd} >> ${logf}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-0 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-0 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld0.txt ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-0 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld0.data ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-0 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-1 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-1 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld1.txt ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-1 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld1.data ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-1 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-2 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-2 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld2.txt ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-2 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld2.data ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-2 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-3 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-3 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld3.txt ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-3 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld3.data ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-3 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-4 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-4 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld4.txt ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-4 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld4.data ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-4 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-5 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-5 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld5.txt ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-5 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld5.data ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-5 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-6 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-6 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld6.txt ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-6 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld6.data ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-6 >&${logfd}
echo 'end' >&0

logf=logs/flog-bld-rmallochoard.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard0.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard0.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard1.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard1.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard2.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard2.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-3 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-3 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard3.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-3 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard3.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-3 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-4 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-4 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard4.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-4 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard4.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-4 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-5 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-5 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard5.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-5 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard5.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-5 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-6 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-6 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard6.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-6 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallochoard6.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=hoard-6 >&${logfd}
echo 'end hoard' >&0

logf=logs/flog-bld-rmallocjemalloc.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc0.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc0.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc1.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc1.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc2.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc2.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-3 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-3 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc3.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-3 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc3.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-3 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-4 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-4 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc4.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-4 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc4.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-4 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-5 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-5 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc5.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-5 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc5.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-5 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-6 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-6 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc6.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-6 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocjemalloc6.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=jemalloc-6 >&${logfd}
echo 'end jemalloc' >&0

logf=logs/flog-bld-rmallocnedmalloc.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc0.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc0.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc1.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc1.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc2.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc2.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-3 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-3 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc3.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-3 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc3.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-3 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-4 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-4 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc4.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-4 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc4.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-4 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-5 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-5 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc5.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-5 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc5.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-5 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-6 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-6 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc6.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-6 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/render/perf/bld-rmallocnedmalloc6.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=nedmalloc-6 >&${logfd}
echo 'end nedmalloc' >&0

logf=logs/flog-bld-rmallocrmalloc-log.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-rmalloc0.txt
mv ./trace ../../results/firefox/render/trace/trace-rmalloc0.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-rmalloc1.txt
mv ./trace ../../results/firefox/render/trace/trace-rmalloc1.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-rmalloc2.txt
mv ./trace ../../results/firefox/render/trace/trace-rmalloc2.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-rmalloc3.txt
mv ./trace ../../results/firefox/render/trace/trace-rmalloc3.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-rmalloc4.txt
mv ./trace ../../results/firefox/render/trace/trace-rmalloc4.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-rmalloc5.txt
mv ./trace ../../results/firefox/render/trace/trace-rmalloc5.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-rmalloc6.txt
mv ./trace ../../results/firefox/render/trace/trace-rmalloc6.txt
echo 'end rmalloc-log' >&0

logf=logs/flog-bld-rmallochoard-log.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard0.txt
mv ./trace ../../results/firefox/render/trace/trace-hoard0.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard1.txt
mv ./trace ../../results/firefox/render/trace/trace-hoard1.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard2.txt
mv ./trace ../../results/firefox/render/trace/trace-hoard2.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard3.txt
mv ./trace ../../results/firefox/render/trace/trace-hoard3.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard4.txt
mv ./trace ../../results/firefox/render/trace/trace-hoard4.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard5.txt
mv ./trace ../../results/firefox/render/trace/trace-hoard5.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard6.txt
mv ./trace ../../results/firefox/render/trace/trace-hoard6.txt
echo 'end hoard-log' >&0

kill `ps --no-header -C php -o pid`
echo 'all done :D' >&0
