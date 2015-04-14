../source/firefox-bld/dist/bin/firefox -CreateProfile jsbench
../source/firefox-bld/dist/bin/firefox -CreateProfile renderbench

mkdir Firefox/logs

sudo mkdir /ramdisk

cd ../results
mkdir -p firefox/js/perf firefox/js/trace firefox/render/perf firefox/render/trace sqlite/perf sqlite/trace