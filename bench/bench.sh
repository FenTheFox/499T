#!/usr/bin/zsh

echo $@

cd Firefox
./js.rb $@
./render.rb $@
./js.sh
./render.sh

cd ../SQLite
./bench.rb $@

cd $1/results
./results.sh