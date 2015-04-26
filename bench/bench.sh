#!/usr/bin/zsh

setopt NULL_GLOB

cd ..
export BASE_DIR=`pwd`

ffr_base=$BASE_DIR/results/firefox
sqlr_base=$BASE_DIR/results/sqlite

if [[ $1 == '-ff' || $2 == '-ff' ]]; then
	ff=true
	rm -rf $ffr_base/logs/*
fi
if [[ $1 == '-sql' || $2 == '-sql' ]]; then
	sql=true
	rm -f $sqlr_base/logs/*
	cd source/sqlite-bench/
	make
	cd $BASE_DIR
fi

for a in $@; do
	if [[ $a == '-bench' ]]; then
		bench='-bench'
		if [[ $ff ]]; then
			rm -f $ffr_base/js/*.txt $ffr_base/render/*.txt
		fi
		if [[ $sql ]]; then
			rm -f $sqlr_base/*.txt
		fi
	elif [[ $a == '-perf' ]]; then
		perf='-perf'
		if [[ $ff ]]; then
			rm -f $ffr_base/**/perf/*
		fi
		if [[ $sql ]]; then
			rm -f $sqlr_base/perf/*
		fi
	elif [[ $a == '-trace' ]]; then
		trace='-trace'
		if [[ $ff ]]; then
			rm -f $ffr_base/**/trace/*
		fi
		if [[ $sql ]]; then
			rm -f $sqlr_base/trace/*
		fi
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
	sqli=31
fi

sudo mount none -t tmpfs -o size=4G /ramdisk

cp -rfL bench bin Replace-Libs /ramdisk
rsync -r -f '+ */' -f '- *' results /ramdisk

args=($bench $perf $trace)

if [[ $ff ]]; then
	cd /ramdisk/bench/Firefox
	./js.rb $jsi $args
	./render.rb $reni $args
	chmod 755 *.sh
	./js.sh
	./render.sh
fi

if [[ $sql ]]; then
	cd /ramdisk/bench/SQLite
	./gen_queries.rb
	./bench.rb $sqli $args
fi

cp -rf /ramdisk/results/* $BASE_DIR/results

if [[ $warmup != true ]]; then
	cd $BASE_DIR/results
	./results.sh
fi

cd $BASE_DIR
sudo umount /ramdisk

unset BASE_DIR