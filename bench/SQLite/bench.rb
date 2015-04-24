#!/usr/bin/ruby

require 'fileutils'
require 'pry'

class Bench
	@@mems = ['mem3', 'mem5']
	@@sizes = ['128kb', '1mb', '16mb']

	@@itrs = 7
	@@flags = '-q -s 8'
	@@schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
	@@queries = 'query1.sql query2.sql query2-1.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'

	@@do_perf = @@do_trace = @@do_bench = false

	def self.parse_args
		@@base_results_dir = ENV['BASE_DIR'] + '/results/sqlite'
		@@results_dir = '../../results/sqlite'
		ARGV.each do |a|
			@@do_bench = true if a == '-bench'
			@@do_perf = true if a == '-perf'
			@@do_trace = true if a == '-trace'
		end
	end

	def self.do_bench(itr)
		run_test('sys', "sys-#{itr}", nil, true)

		@@mems.each do |m|
			@@sizes.each { |sz| run_test("#{m}-#{sz}", "#{m}-#{sz}-#{itr}", nil, true) }
		end

		['hoard', 'jemalloc', 'nedmalloc'].each do |lib|
			run_test('sys', "#{lib}-#{itr}", lib, true)
		end
	end

	def self.do_log(itr)
		return if !@@do_trace

		@@mems.each do |m|
			@@sizes.each do |sz|
				run_test("#{m}log#{sz}", "logs/#{m}-#{sz}-#{itr}log")
				mv_trace("#{m}-#{sz}-#{itr}")
			end
		end

		['hoard'].each do |lib|
			run_test('sys', "logs/#{lib}-#{itr}log", "#{lib}-log")
			mv_trace("#{lib}-#{itr}")
		end
	end

private
	def self.run_test(bld, resultsf, lib=nil, perf = false)
		c = "../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries}"
		cmd = ''
		cmd += "LD_PRELOAD=../../Replace-Libs/lib#{lib}.so " if !lib.nil?
		cmd_perf = cmd + "perf stat -e -o #{@@base_results_dir}/perf/#{resultsf}.txt "
		cmd += "#{c} >> #{@@results_dir}/#{resultsf}.txt"
		cmd_perf += "#{c} >> #{@@results_dir}/logs/#{resultsf}perf.txt"

		tries = 0
		if @@do_bench
			puts cmd
			puts $? while((result = Kernel.system(cmd)) != true && (tries += 1) < 8)
		end

		if(perf && @@do_perf)
			puts cmd_perf.gsub('-e', '-e cycles,instructions,cache-misses,branch-misses,page-faults,cs')
			puts cmd_perf.gsub('stat', 'record').gsub('-e', '--call-graph dwarf').gsub('.txt', '.data')

			puts $? while((result = Kernel.system(cmd_perf.gsub('-e', '-e cycles,instructions,cache-misses,branch-misses,page-faults,cs'))) != true && (tries += 1) < 10)
			puts $? while((result = Kernel.system(cmd_perf.gsub('stat', 'record').gsub('-e', '--call-graph dwarf').gsub('.txt', '.data'))) != true && (tries += 1) < 10)
		end
	end

	def self.mv_trace(bld)
		begin
			FileUtils.mv('./max', "#{@@base_results_dir}/trace/max-#{bld}.txt")
			FileUtils.mv('./trace', "#{@@base_results_dir}/trace/trace-#{bld}.txt")
		rescue Exception => e
			puts 'welp'
			puts e
		end
	end
end

Bench.parse_args
itrs = ARGV[0].to_i
itrs.times { |n| Bench.do_bench(n) }
itrs.times { |n| Bench.do_log(n) }