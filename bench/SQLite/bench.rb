#!/usr/bin/ruby

require 'fileutils'

def run_test(bld, log=nil)
	itrs = 30
	flags = '-q -s 8'
	schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
	queries = 'query1.sql query2.sql query2-1.sql query.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'
	
	p [bld, log]
	# puts "../../bin/sqlite/sqlite3-#{bld} #{itrs} #{flags} #{schema} #{queries} > ../../results/sqlite/#{log}.txt"

	if !log.nil?
		# pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{itrs} #{flags} #{schema} #{queries}")
		pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{itrs} #{flags} #{schema} #{queries} > ../../results/sqlite/#{log}.txt")
	else
		pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{itrs} #{flags} #{schema} #{queries} > /dev/null")
	end

	Process.wait(pid)
end

def mv_trace(bld)
	begin
		FileUtils.mv('./max', '../../results/sqlite/trace/max-' + bld)
		FileUtils.mv('./trace', '../../results/sqlite/trace/trace-' + bld)
	rescue Exception => e
		p "welp"
	end
end

def do_bench(itr)
	run_test('sys', "sys-#{itr}")
	run_test('mem3', "mem3-#{itr}")
	run_test('mem5', "mem5-#{itr}")

	libs = ['hoard', 'jemalloc', 'nedmalloc']

	libs.each do |l|
		ENV['LD_PRELOAD'] = '../../Replace-Libs/lib' + l + '.so'
		run_test('rmalloc', "#{l}-#{itr}")
	end
	ENV['LD_PRELOAD'] = nil
end

def do_log
	run_test('mem3log')
	mv_trace('mem3log')
	run_test('mem5log')
	mv_trace('mem5log')

	['hoard'].each do |l|
		ENV['LD_PRELOAD'] = '../../Replace-Libs/lib' + l + '-log.so'
		run_test('rmalloc')
		mv_trace(l)
	end
	ENV['LD_PRELOAD'] = nil
end

3.times do |n|
	do_bench(n)
	# do_log
end