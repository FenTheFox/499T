#!/usr/bin/zsh

integer logfd
integer glogfd
glogf=logs/js.log
exec {glogfd} >> ${glogf}
exec >&${glogfd} 2>&1

echo 'php -S localhost:8000 -t jsbench -c php.ini &' >&0
php -S localhost:8000 -t jsbench -c php.ini &

logf=logs/flog-bld
exec {logfd} >> ${logf}
echo '../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'end' >&0

echo 'perf stat -o ../../results/firefox/js/perf/bld0 ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld0 ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld1 ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld1 ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld2 ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld2 ../../source/firefox-bld/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'end' >&0

logf=logs/flog-bld-rmallochoard
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'end hoard' >&0

echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallochoard0 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallochoard0 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallochoard1 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallochoard1 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallochoard2 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallochoard2 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'end hoard' >&0

logf=logs/flog-bld-rmallocjemalloc
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'end jemalloc' >&0

echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallocjemalloc0 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallocjemalloc0 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallocjemalloc1 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallocjemalloc1 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallocjemalloc2 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallocjemalloc2 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'end jemalloc' >&0

logf=logs/flog-bld-rmallocnedmalloc
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'end nedmalloc' >&0

echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallocnedmalloc0 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallocnedmalloc0 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallocnedmalloc1 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallocnedmalloc1 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/js/perf/bld-rmallocnedmalloc2 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/js/perf/bld-rmallocnedmalloc2 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'end nedmalloc' >&0

logf=logs/flog-bld-rmalloc-log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/js/trace/max-default0
mv ./trace ../../results/firefox/js/trace/trace-default0
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/js/trace/max-default1
mv ./trace ../../results/firefox/js/trace/trace-default1
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/js/trace/max-default2
mv ./trace ../../results/firefox/js/trace/trace-default2
echo 'end log' >&0

logf=logs/flog-bld-rmallochoard-log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/js/trace/max-hoard0
mv ./trace ../../results/firefox/js/trace/trace-hoard0
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/js/trace/max-hoard1
mv ./trace ../../results/firefox/js/trace/trace-hoard1
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P jsbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/js/trace/max-hoard2
mv ./trace ../../results/firefox/js/trace/trace-hoard2
echo 'end hoard-log' >&0

echo 'end end' >&0
kill `ps --no-header -C php -o pid`
