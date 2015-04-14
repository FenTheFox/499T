#!/usr/bin/zsh

echo $@

cd Firefox
./js.rb $1 $2 $3
./render.rb $1 $2 $3
./js.sh
./render.sh

cd ../SQLite
./bench.rb $1 $2 $3

cp -rf /ramdisk/results $1

cd $1/results
./results.sh