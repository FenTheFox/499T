#!/usr/bin/ruby

require 'fileutils'

class Bench
	@@mems = ['mem3', 'mem5']
	@@sizes = ['', '-128kb', '-16mb']

	@@itrs = 30
	@@flags = '-q -s 8'
	@@schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
	@@queries = 'query1.sql query2.sql query2-1.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'

	def self.do_bench(itr)
		run_test('sys', "sys-#{itr}", nil, itr)

		@@mems.each do |m|
			@@sizes.each { |sz| run_test("#{m}#{sz}", "#{m}#{sz}-#{itr}", nil, itr) }
		end

		['hoard', 'jemalloc', 'nedmalloc'].each do |lib|
			run_test('rmalloc', "#{lib}-#{itr}", lib, itr)
		end
	end

	def self.do_log(itr)
		@@mems.each do |m|
			@@sizes.each do |sz|
				run_test("#{m}log#{sz}")
				mv_trace("#{m}log#{sz}-#{itr}")
			end
		end

		['hoard'].each do |lib|
			run_test('rmalloc', nil, "#{lib}-log")
			mv_trace("#{lib}-#{itr}")
		end
	end

private
	def self.run_test(bld, log=nil, lib=nil, perf = -1)
		cmd = ''
		cmd += "LD_PRELOAD=../../Replace-Libs/lib#{lib}.so " if !lib.nil?
		cmd_perf = cmd + "perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/sqlite/perf/#{log}.txt "
		cmd += "../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries} > "
		cmd_perf += "../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries} > /dev/null"
		if log.nil?
			cmd += '/dev/null'
		else
			cmd += "../../results/sqlite/#{log}.txt"
		end

		puts cmd

		Kernel.system(cmd)
		if perf >= 0
			puts cmd_perf.gsub('stat', 'record').gsub('.txt', '.data')
			Kernel.system(cmd_perf)
			Kernel.system(cmd_perf.gsub('stat', 'record').gsub('.txt', '.data'))
		end
	end

	def self.mv_trace(bld)
		begin
			FileUtils.mv('./max', '../../results/sqlite/trace/max-' + bld)
			FileUtils.mv('./trace', '../../results/sqlite/trace/trace-' + bld)
		rescue Exception => e
			puts 'welp'
			puts e
		end
	end
end

5.times { |n| Bench.do_bench(n) }
sleep(5)
5.times { |n| Bench.do_log(n) }