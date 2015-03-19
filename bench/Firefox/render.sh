#!/usr/bin/zsh

integer logfd
integer glogfd
glogf=logs/js.log
exec {glogfd} >> ${glogf}
exec >&${glogfd} 2>&1

echo 'php -S localhost:8000 -t renderbench -c php.ini &' >&0
php -S localhost:8000 -t renderbench -c php.ini &

logf=logs/flog-bld
exec {logfd} >> ${logf}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo '../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'end' >&0

echo 'perf stat -o ../../results/firefox/render/perf/bld0 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld0 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld1 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld1 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld2 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld2 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld3 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld3 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld4 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld4 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld5 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld5 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld6 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld6 ../../source/firefox-bld/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld >&${logfd}
echo 'end' >&0

logf=logs/flog-bld-rmallochoard
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'end hoard' >&0

echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallochoard0 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallochoard0 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallochoard1 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallochoard1 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallochoard2 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallochoard2 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallochoard3 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallochoard3 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallochoard4 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallochoard4 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallochoard5 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallochoard5 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallochoard6 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallochoard6 LD_PRELOAD=../../Replace-Libs/libhoard.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard >&${logfd}
echo 'end hoard' >&0

logf=logs/flog-bld-rmallocjemalloc
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'end jemalloc' >&0

echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc0 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc0 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc1 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc1 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc2 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc2 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc3 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc3 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc4 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc4 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc5 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc5 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc6 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocjemalloc6 LD_PRELOAD=../../Replace-Libs/libjemalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocjemalloc >&${logfd}
echo 'end jemalloc' >&0

logf=logs/flog-bld-rmallocnedmalloc
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'end nedmalloc' >&0

echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc0 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc0 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc1 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc1 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc2 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc2 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc3 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc3 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc4 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc4 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc5 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc5 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc6 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}' >&0
perf stat -o ../../results/firefox/render/perf/bld-rmallocnedmalloc6 LD_PRELOAD=../../Replace-Libs/libnedmalloc.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocnedmalloc >&${logfd}
echo 'end nedmalloc' >&0

logf=logs/flog-bld-rmalloc-log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-default0
mv ./trace ../../results/firefox/render/trace/trace-default0
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-default1
mv ./trace ../../results/firefox/render/trace/trace-default1
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-default2
mv ./trace ../../results/firefox/render/trace/trace-default2
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-default3
mv ./trace ../../results/firefox/render/trace/trace-default3
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-default4
mv ./trace ../../results/firefox/render/trace/trace-default4
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-default5
mv ./trace ../../results/firefox/render/trace/trace-default5
echo 'LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/librmalloc-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallocrmalloc-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-default6
mv ./trace ../../results/firefox/render/trace/trace-default6
echo 'end log' >&0

logf=logs/flog-bld-rmallochoard-log
exec {logfd} >> ${logf}
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard0
mv ./trace ../../results/firefox/render/trace/trace-hoard0
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard1
mv ./trace ../../results/firefox/render/trace/trace-hoard1
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard2
mv ./trace ../../results/firefox/render/trace/trace-hoard2
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard3
mv ./trace ../../results/firefox/render/trace/trace-hoard3
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard4
mv ./trace ../../results/firefox/render/trace/trace-hoard4
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard5
mv ./trace ../../results/firefox/render/trace/trace-hoard5
echo 'LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}' >&0
LD_PRELOAD=../../Replace-Libs/libhoard-log.so ../../source/firefox-bld-rmalloc/dist/bin/firefox -P renderbench localhost:8000/index.php\?bld=bld-rmallochoard-log >&${logfd}
mv ./max ../../results/firefox/render/trace/max-hoard6
mv ./trace ../../results/firefox/render/trace/trace-hoard6
echo 'end hoard-log' >&0

echo 'end end' >&0
kill `ps --no-header -C php -o pid`
