#!/usr/bin/ruby

class Tester
	@@root = 'localhost:8000'
	@@libs = ['hoard', 'jemalloc', 'nedmalloc']

	def initialize (profile, timeout, iters)
		@profile = profile
		@timeout = timeout
		@iters = iters
		ARGV.each do |a|
			@do_perf = true unless a.index('with-perf').nil?
			@do_trace = true unless a.index('with-trace').nil?
		end

		puts '#!/usr/bin/zsh'
		puts ''
		puts 'integer logfd'
		puts 'integer glogfd'
		puts "glogf=logs/#{profile}.log"
		puts 'exec {glogfd} >> ${glogf}'
		puts 'exec >&${glogfd} 2>&1'
		puts ''

		puts "echo 'php -S localhost:8000 -t #{profile}bench -c php.ini &' >&0"
		puts "php -S #{@@root} -t #{profile}bench -c php.ini &"
		puts ''
	end

	def do_test(bld, ittr = -1, lib = nil)
		cmd = ''
		cmd += "LD_PRELOAD=../../Replace-Libs/lib#{lib}.so " if !lib.nil?
		cmd_perf = cmd + "perf stat -e cycles,instructions,cache-misses,branch-misses,page-faults,cs -o ../../results/firefox/#{@profile}/perf/#{bld}#{lib}#{ittr}.txt "
		ittr < 0 ? log = '' : log = "bld=#{lib.nil? ? bld : lib}-#{ittr}"
		cmd += "../../source/firefox-#{bld}/dist/bin/firefox -P #{@profile}bench #{@@root}/index.php\\?#{log} >&${logfd}"
		cmd_perf += "../../source/firefox-#{bld}/dist/bin/firefox -P #{@profile}bench #{@@root}/index.php >&${logfd}"

		puts "echo '#{cmd}' >&0"
		puts cmd
		if(ittr >= 0 && @do_perf)
			puts cmd_perf
			puts cmd_perf.gsub('stat', 'record').gsub('.txt', '.data')
		end
	end

	def do_tests()
		puts 'logf=logs/flog-bld.log'
		puts 'exec {logfd} >> ${logf}'
		@iters.times { |n| do_test('bld', n) }
		puts "echo 'end' >&0"
		puts ''

		['hoard', 'jemalloc', 'nedmalloc'].each do |lib|
			puts "logf=logs/flog-bld-rmalloc#{lib}.log"
			puts 'exec {logfd} >> ${logf}'
			@iters.times { |n| do_test('bld-rmalloc', n, lib) }
			puts "echo 'end #{lib}' >&0"
			puts ''
		end

		if @do_trace
			['rmalloc', 'hoard'].each do |lib|
				puts "logf=logs/flog-bld-rmalloc#{lib}-log.log"
				puts 'exec {logfd} >> ${logf}'
				@iters.times do |n|
					do_test('bld-rmalloc', -1, lib + '-log')
					puts "mv ./max ../../results/firefox/#{@profile}/trace/max-#{lib}#{n}.txt"
					puts "mv ./trace ../../results/firefox/#{@profile}/trace/trace-#{lib}#{n}.txt"
				end
				puts "echo 'end #{lib}-log' >&0"
				puts ''
			end
		end

		puts 'kill `ps --no-header -C php -o pid`'
		puts "echo 'all done :D' >&0"
	end
end