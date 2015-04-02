#!/usr/bin/ruby

require 'fileutils'

class Bench
	@@mems = ['mem3', 'mem5']
	@@sizes = ['', '-128kb', '-16mb']

	@@itrs = 30
	@@flags = '-q -s 8'
	@@schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
	@@queries = 'query1.sql query2.sql query2-1.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'

	@@results_base = '../../results/sqlite'

	@@do_perf = @@do_trace = false

	def self.parse_args
		ARGV.each do |a|
			@@do_perf = true unless a.index('with-perf').nil?
			@@do_trace = true unless a.index('with-trace').nil?
		end
	end

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
		return if !@@do_trace
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
		cmd_perf = cmd + "perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o #{@@results_base}/perf/#{log}.txt "
		cmd += "../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries} > "
		cmd_perf += "../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries} > /dev/null"
		if log.nil?
			cmd += '/dev/null'
		else
			cmd += "#{@@results_base}/#{log}.txt"
		end

		puts cmd

		while((result = Kernel.system(cmd)).nil?)
			puts $?
		end

		if(perf >= 0 && @@do_perf)
			puts cmd_perf.gsub('stat', 'record').gsub('.txt', '.data')
			Kernel.system(cmd_perf)
			Kernel.system(cmd_perf.gsub('stat', 'record').gsub('.txt', '.data'))
		end
	end

	def self.mv_trace(bld)
		begin
			FileUtils.mv('./max', "#{@@results_base}/trace/max-#{bld}.txt")
			FileUtils.mv('./trace', "#{@@results_base}/trace/trace-#{bld}.txt")
		rescue Exception => e
			puts 'welp'
			puts e
		end
	end
end

Bench.parse_args

5.times { |n| Bench.do_bench(n) }
sleep(5)
5.times { |n| Bench.do_log(n) }