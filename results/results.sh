#!/usr/bin/zsh

base=`pwd`
echo $1

cd firefox
./parse.rb

cd $base/sqlite
./results.rb

if [[ $2 == '-perf' || $3 == '-perf' ]]; then
	if [[ $1 == '-ff' && $1 == '-ff' ]]; then
		cd js/perf
		gnome-terminal --tab -e 'zsh -c "perf report -g graph -n -i bld.data              | tee bldr.txt      && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" bldr.txt > bldg.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i hoard-rmalloc.data    | tee hoardr.txt    && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" hoardr.txt > hoardg.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i jemalloc-rmalloc.data | tee jemallocr.txt && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" jemallocr.txt > jemallocg.txt"'
		cd ../../render/perf
		gnome-terminal --tab -e 'zsh -c "perf report -g graph -n -i bld.data              | tee bldr.txt      && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" bldr.txt > bldg.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i hoard-rmalloc.data    | tee hoardr.txt    && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" hoardr.txt > hoardg.txt"'
		               --tab -e 'zsh -c "perf report -g graph -n -i jemalloc-rmalloc.data | tee jemallocr.txt && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" jemallocr.txt > jemallocg.txt"'
	fi
	if [[ $1 == '-sql' || $2 == '-sql' ]]; then
		cd perf
		gnome-terminal --tab -e 'zsh -c "perf report -g graph -n -i sys.data       | tee sysr.txt       && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" sysr.txt > sysg.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i mem3-32.data   | tee mem3-32r.txt   && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" mem3-32r.txt > mem3-32g.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i mem3-128.data  | tee mem3-128r.txt  && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" mem3-128r.txt > mem3-128g.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i mem5-32.data   | tee mem5-32r.txt   && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" mem5-32r.txt > mem5-32g.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i mem5-128.data  | tee mem5-128r.txt  && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" mem5-128r.txt > mem5-128g.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i hoard.data     | tee hoardr.txt     && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" hoardr.txt > hoardg.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i jemalloc.data  | tee jemallocr.txt  && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" jemallocr.txt > jemallocg.txt"'\
		               --tab -e 'zsh -c "perf report -g graph -n -i nedmalloc.data | tee nedmallocr.txt && grep -E \"[0-9]{1,2}\.[0-9]{2}%.*((m|r|c)alloc|free|arena)\" nedmallocr.txt > nedmallocg.txt"'
	fi
fi