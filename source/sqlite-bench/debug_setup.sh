#!/usr/bin/zsh

setopt NULL_GLOB

make

cd ../..
export BASE_DIR=`pwd`

sudo umount /ramdisk
sudo mount none -t tmpfs -o size=2G /ramdisk

cp -rfL bench bin Replace-Libs /ramdisk
rsync -r -f '+ */' -f '- *' results /ramdisk

cd /ramdisk/bench/SQLite
./gen_queries.rb