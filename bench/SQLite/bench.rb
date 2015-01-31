#!/usr/bin/ruby

require 'fileutils'

class Bench
	@@mems = ['mem3', 'mem5']
	@@sizes = ['', '-128kb', '-16mb']

	@@itrs = 30
	@@flags = '-q -s 8'
	@@schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
	@@queries = 'query1.sql query2.sql query2-1.sql query.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'

	def self.do_bench(itr)

		run_test('sys', "sys-#{itr}")

		@@mems.each do |m|
			@@sizes.each { |sz| run_test("#{m}#{sz}", "#{m}#{sz}-#{itr}") }
		end

		libs = ['hoard', 'jemalloc', 'nedmalloc']

		libs.each do |l|
			ENV['LD_PRELOAD'] = '../../Replace-Libs/lib' + l + '.so'
			run_test('rmalloc', "#{l}-#{itr}")
		end
		ENV['LD_PRELOAD'] = nil
	end

	def self.do_log(itr)
		@@mems.each do |m|
			@@sizes.each do |sz|
				run_test("#{m}log#{sz}")
				mv_trace("#{m}log#{sz}-#{itr}")
			end
		end

		['hoard'].each do |l|
			ENV['LD_PRELOAD'] = '../../Replace-Libs/lib' + l + '-log.so'
			run_test('rmalloc')
			mv_trace("#{l}-#{itr}")
		end
		ENV['LD_PRELOAD'] = nil
	end

private
	def self.run_test(bld, log=nil)		
		p [bld, log]
		# puts "../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries} > ../../results/sqlite/#{log}.txt"

		if !log.nil?
			# pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries}")
			pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries} > ../../results/sqlite/#{log}.txt")
		else
			pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{@@itrs} #{@@flags} #{@@schema} #{@@queries} > /dev/null")
		end

		Process.wait(pid)
	end

	def self.mv_trace(bld)
		begin
			FileUtils.mv('./max', '../../results/sqlite/trace/max-' + bld)
			FileUtils.mv('./trace', '../../results/sqlite/trace/trace-' + bld)
		rescue Exception => e
			p "welp"
		end
	end
end

3.times do |n|
	Bench.do_bench(n)
	# Bench.do_log(n)
end