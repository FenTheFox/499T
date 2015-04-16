#!/usr/bin/zsh

setopt NULL_GLOB

cd ..
base_dir=`pwd`

rm -f $base_dir/bench/**/logs/* $base_dir/results/firefox/js/*.txt $base_dir/results/firefox/render/*.txt $base_dir/results/sqlite/*.txt
if [[ ($1 =~ with-perf) || ($2 =~ with-perf) ]]; then
	perf="--with-perf"
	rm -f $base_dir/results/**/perf/*
fi

if [[ ($1 =~ with-trace) || ($2 =~ with-trace) ]]; then
	trace="--with-trace"
	rm -f $base_dir/results/**/trace/*
fi

if [[ $1 =~ warmup ]]; then
	jsi=1
	reni=1
	sqli=1
else
	jsi=3
	reni=7
	sqli=5
fi

sudo mount none -t tmpfs -o size=4G /ramdisk

cp -rf bench bin Replace-Libs /ramdisk
rsync -r -f "+ */" -f "- *" results /ramdisk

cd /ramdisk/bench/Firefox
./js.rb $base_dir $jsi $perf $trace
./render.rb $base_dir $reni $perf $trace
chmod 755 *.sh
./js.sh
./render.sh

cd ../SQLite
./bench.rb $base_dir $sqli $perf $trace

cp -rf /ramdisk/results $base_dir

cd $base_dir/results
./results.sh