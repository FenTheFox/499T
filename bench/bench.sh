#!/usr/bin/zsh

setopt NULL_GLOB

cd ..
export BASE_DIR=`pwd`

rm -f $BASE_DIR/bench/**/logs/*

for a in $@; do
	if [[ $a == '-bench' ]]; then
		bench='-bench'
		rm -f $BASE_DIR/results/firefox/js/*.txt $BASE_DIR/results/firefox/render/*.txt $BASE_DIR/results/sqlite/*.txt
	elif [[ $a == '-perf' ]]; then
		perf='-perf'
		rm -f $BASE_DIR/results/**/perf/*
	elif [[ $a == '-trace' ]]; then
		trace='-trace'
		rm -f $BASE_DIR/results/**/trace/*
	elif [[ $a == '-warmup' ]]; then
		warmup=true
	fi
done

if [[ $warmup ]]; then
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
rsync -r -f '+ */' -f '- *' results /ramdisk

args=($bench $perf $trace)

cd /ramdisk/bench/Firefox
./js.rb $jsi $args
./render.rb $reni $args
chmod 755 *.sh
./js.sh
./render.sh

cd ../SQLite
./bench.rb $sqli $args

cp -rf /ramdisk/results/* $BASE_DIR/results

if [[ $warmup != true ]]; then
	cd $BASE_DIR/results
	./results.sh
else
	cd $BASE_DIR/bench
	./cleanup.sh
fi

unset BASE_DIR