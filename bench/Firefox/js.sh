#!/usr/bin/zsh

integer logfd
integer glogfd
glogf=logs/js.log
exec {glogfd} >> ${glogf}
exec >&${glogfd} 2>&1

echo 'php -S localhost:8000 -t jsbench -c php.ini &' >&0
php -S localhost:8000 -t jsbench -c php.ini &

logf=logs/flog-bld.log
exec {logfd} >> ${logf}
echo '../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-0 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-0 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld0.txt ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-0 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld0.data ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-0 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-1 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-1 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld1.txt ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-1 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld1.data ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-1 >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-2 >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-2 >&${logfd}
perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld2.txt ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-2 >&${logfd}
perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld2.data ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-2 >&${logfd}
echo 'end' >&0

logf=logs/flog-bld-rmallochoard.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallochoard0.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallochoard0.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-0 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallochoard1.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallochoard1.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-1 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallochoard2.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libhoard.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallochoard2.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=hoard-2 >&${logfd}
echo 'end hoard' >&0

logf=logs/flog-bld-rmallocjemalloc.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocjemalloc0.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocjemalloc0.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-0 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocjemalloc1.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocjemalloc1.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-1 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocjemalloc2.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libjemalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocjemalloc2.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=jemalloc-2 >&${logfd}
echo 'end jemalloc' >&0

logf=logs/flog-bld-rmallocnedmalloc.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocnedmalloc0.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocnedmalloc0.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-0 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocnedmalloc1.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocnedmalloc1.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-1 >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocnedmalloc2.txt ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so perf record -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/js/perf/bld-rmallocnedmalloc2.data ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=nedmalloc-2 >&${logfd}
echo 'end nedmalloc' >&0

logf=logs/flog-bld-rmallocrmalloc-log.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/js/trace/max-rmalloc0.txt
mv ./trace ../../results/firefox/js/trace/trace-rmalloc0.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/js/trace/max-rmalloc1.txt
mv ./trace ../../results/firefox/js/trace/trace-rmalloc1.txt
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/js/trace/max-rmalloc2.txt
mv ./trace ../../results/firefox/js/trace/trace-rmalloc2.txt
echo 'end rmalloc-log' >&0

logf=logs/flog-bld-rmallochoard-log.log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/js/trace/max-hoard0.txt
mv ./trace ../../results/firefox/js/trace/trace-hoard0.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/js/trace/max-hoard1.txt
mv ./trace ../../results/firefox/js/trace/trace-hoard1.txt
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\? >&${logfd}
mv ./max ../../results/firefox/js/trace/max-hoard2.txt
mv ./trace ../../results/firefox/js/trace/trace-hoard2.txt
echo 'end hoard-log' >&0

kill `ps --no-header -C php -o pid`
echo 'all done :D' >&0
