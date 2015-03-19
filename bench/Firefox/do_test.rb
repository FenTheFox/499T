#!/usr/bin/ruby

require 'timeout'
require 'net/http'
require 'fileutils'

class Tester
	@@root = 'localhost:8000'
	@@libs = ['hoard', 'jemalloc', 'nedmalloc']

	def initialize (profile, timeout, iters)
		@profile = profile
		@timeout = timeout
		@iters = iters

		puts '#!/usr/bin/zsh'
		puts ''
		puts 'integer logfd'
		puts 'integer glogfd'
		puts 'glogf=logs/js.log'
		puts 'exec {glogfd} >> ${glogf}'
		puts 'exec >&${glogfd} 2>&1'
		puts ''

		puts "echo 'php -S localhost:8000 -t jsbench -c php.ini &' >&0"
		puts "php -S #{@@root} -t #{profile}bench -c php.ini &"
		puts ''
	end

	def do_test(bld, lib = '', perf = -1)
		cmd = ''
		cmd += "perf stat -o ../../results/firefox/#{@profile}/perf/#{bld}#{lib}#{perf} " if perf >= 0
		cmd += "LD_PRELOAD=../../Replace-Libs/lib#{lib}.so " if !lib.nil? && lib.size > 0
		cmd += "../../source/firefox-#{bld}/dist/bin/firefox -P #{@profile}bench #{@@root}/index.php\\?bld=#{bld}#{lib} >&${logfd}"

		puts "echo '#{cmd}' >&0"
		puts cmd
	end

	def do_tests()
		puts 'logf=logs/flog-bld'
		puts 'exec {logfd} >> ${logf}'
		@iters.times { |n| do_test('bld') }
		puts "echo 'end' >&0"
		puts ''
		@iters.times { |n| do_test('bld', '', n) }
		puts "echo 'end' >&0"
		puts ''

		['hoard', 'jemalloc', 'nedmalloc'].each do |lib|
			puts "logf=logs/flog-bld-rmalloc#{lib}"
			puts 'exec {logfd} >> ${logf}'
			@iters.times { |n| do_test('bld-rmalloc', lib) }
			puts "echo 'end #{lib}' >&0"
			puts ''
			@iters.times { |n| do_test('bld-rmalloc', lib, n) }
			puts "echo 'end #{lib}' >&0"
			puts ''
		end
		
		puts "logf=logs/flog-bld-rmalloc-log"
		puts 'exec {logfd} >> ${logf}'
		@iters.times do |n|
			do_test('bld-rmalloc', 'rmalloc-log')
			puts "mv ./max ../../results/firefox/#{@profile}/trace/max-default#{n}"
			puts "mv ./trace ../../results/firefox/#{@profile}/trace/trace-default#{n}"
		end
		puts 'end log'
		puts ''

		['hoard'].each do |lib|
			puts "logf=logs/flog-bld-rmalloc#{lib}-log"
			puts 'exec {logfd} >> ${logf}'
			@iters.times do |n|
				do_test('bld-rmalloc', lib + '-log')
				puts "mv ./max ../../results/firefox/#{@profile}/trace/max-#{lib}#{n}"
				puts "mv ./trace ../../results/firefox/#{@profile}/trace/trace-#{lib}#{n}"
			end
			puts "end #{lib}-log"
			puts ''
		end

		# puts 'unset LD_PRELOAD'
		puts 'end end'
		puts 'kill `ps --no-header -C php -o pid`'
	end
end