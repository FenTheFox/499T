#!/usr/bin/zsh

setopt NULL_GLOB

cd ..
base_dir=`pwd`
ffr_base=$base_dir/results/firefox
sqlr_base=$base_dir/results/sqlite

rm -f $base_dir/bench/**/logs/* $ffr_base/js/*.txt $ffr_base/render/*.txt $sqlr_base/*.txt
if [[ ($1 =~ with-perf) || ($2 =~ with-perf) ]]; then
	perf="--with-perf"
	rm -f $base_dir/results/**/perf/*
fi

if [[ ($1 =~ with-trace) || ($2 =~ with-trace) ]]; then
	trace="--with-trace"
	rm -f $base_dir/results/**/trace/*
fi

sudo mount none -t tmpfs -o size=4G /ramdisk
cp -rf bench bin Replace-Libs /ramdisk
cd /ramdisk/bench

rsync -r -f "+ */" -f "- *" $base_dir/results ../

./bench.sh $base_dir $perf $trace