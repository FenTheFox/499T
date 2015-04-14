#!/usr/bin/zsh

setopt NULL_GLOB

cd ..
base_dir=`pwd`
ffr_base=$base_dir/results/firefox
sqlr_base=$base_dir/results/sqlite
args=

rm -f $base_dir/bench/**/logs/* $ffr_base/js/*.txt $ffr_base/render/*.txt $sqlr_base/*.txt
if [[ ($1 =~ with-perf) || ($2 =~ with-perf) ]]; then
	args="$args --with-perf"
	rm -f $base_dir/results/**/perf/*
fi

if [[ ($1 =~ with-trace) || ($2 =~ with-trace) ]]; then
	args="$args --with-trace"
	rm -f $base_dir/results/**/trace/*.txt
fi
echo $args

sudo mount none -t tmpfs -o size=1G /ramdisk
cp -rf bench /ramdisk
cd /ramdisk/bench

cd Firefox
./js.rb $args
./render.rb $args
./js.sh
./render.sh

cd ../SQLite
./bench.rb $args

cd $ffr_base
./parse.rb

cd $sqlr_base
./results.rb

sudo umount /ramdisk