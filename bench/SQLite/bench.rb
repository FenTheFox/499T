#!/usr/bin/ruby

require 'fileutils'
require 'pry'

class Bench
	@@mems = ['mem3', 'mem5']
	@@sizes = ['32', '128']
	@@libs = ['hoard', 'jemalloc', 'nedmalloc']

	@@flags = '-s 8'
	@@schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
	@@queries = 'query1.sql query2.sql query2-1.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'

	@@do_perf = @@do_trace = @@do_bench = false

	def self.run
		@@itrs = ARGV[0].to_i
		@@base_results_dir = ENV['BASE_DIR'] + '/results/sqlite'
		@@results_dir = '../../results/sqlite'
		ARGV.each do |a|
			@@do_bench = true if a == '-bench'
			@@do_perf = true if a == '-perf'
			@@do_trace = true if a == '-trace'
		end

		do_bench()
		do_log() if @@do_trace
	end

	def self.do_bench()
		run_test('sys')

		@@mems.each do |m|
			@@sizes.each { |sz| run_test("#{m}-#{sz}") }
		end

		@@libs.each { |lib| run_test('sys', lib) }
	end

	def self.do_log()
		@@mems.each do |m|
			@@sizes.each do |sz|
				run_test("#{m}log-#{sz}", nil, true)
				mv_trace("#{m}-#{sz}")
			end
		end

		['hoard'].each do |lib|
			run_test('sys', "#{lib}-log", true)
			mv_trace(lib)
		end
	end

private
	def self.run_test(bld, lib=nil, log=false)
		c = "../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries}"
		resultsf = lib.nil? ? bld : lib
		resultsf = 'logs/' + resultsf if log

		cmd = ''
		cmd += "LD_PRELOAD=../../Replace-Libs/lib#{lib}.so " if !lib.nil?
		cmd_perf = cmd + "perf stat -e -o #{@@base_results_dir}/perf/#{resultsf}.txt "
		cmd += "#{c} >> #{@@results_dir}/#{resultsf}.txt"
		cmd_perf += "#{c} >> #{@@results_dir}/logs/#{resultsf}perf.txt"

		tries = 0
		if @@do_bench
			puts cmd
			puts $? while((result = Kernel.system(cmd)) != true && (tries += 1) < 8)
			`rm db*`
		end

		if(!log && @@do_perf)
			puts cmd_perf.gsub('-e', '-e cycles,instructions,cache-misses,branch-misses,page-faults,cs')
			puts cmd_perf.gsub('stat', 'record').gsub('-e', '--call-graph dwarf').gsub('.txt', '.data')

			puts $? while((result = Kernel.system(cmd_perf.gsub('-e', '-e cycles,instructions,cache-misses,branch-misses,page-faults,cs'))) != true && (tries += 1) < 10)
			`rm db*`
			puts $? while((result = Kernel.system(cmd_perf.gsub('stat', 'record').gsub('-e', '--call-graph dwarf').gsub('.txt', '.data'))) != true && (tries += 1) < 10)
			`rm db*`
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

Bench.run()