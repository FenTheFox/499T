#!/usr/bin/ruby

class Tester
	@@PHProot = 'localhost:8000'
	# @@libs = ['hoard', 'jemalloc', 'nedmalloc']
	@@libs = ['hoard', 'jemalloc']

	def initialize (profile, docroot=nil)
		@profile = profile
		@iters = ARGV[0].to_i
		@DOCroot = docroot
		@results_dir = ENV['BASE_DIR'] + '/results/firefox/' + profile
		@logs_dir = ENV['BASE_DIR'] + '/results/firefox/logs'
		@source_dir = ENV['BASE_DIR'] + '/source/firefox-'
		ARGV.each do |a|
			@do_bench = true if a == '-bench'
			@do_perf = true if a == '-perf'
			@do_trace = true if a == '-trace'
		end

		puts '#!/usr/bin/zsh'
		puts ''
		puts 'integer logfd'
		puts 'integer glogfd'
		puts "glogf=#{@logs_dir}/#{profile}.log"
		puts 'exec {glogfd} >> ${glogf}'
		puts 'exec >&${glogfd} 2>&1'
		puts ''

		puts "echo \"gnome-terminal -e 'php -S #{@@PHProot} -t #{profile}bench -c php.ini'\" >&0"
		puts "gnome-terminal -e 'php -S #{@@PHProot} -t #{profile}bench -c php.ini'"
		puts ''
	end

	def do_test(bld, ittr = -1, lib = nil)
		page = @DOCroot.nil? ? "#{@@PHProot}/index.php" : @DOCroot
		cmd = ''
		cmd += "LD_PRELOAD=../../Replace-Libs/lib#{lib}.so " if !lib.nil?
		cmd_perf = cmd + "perf stat -e -o #{@results_dir}/perf/#{lib.nil? ? bld : lib}.txt "
		ittr < 0 ? log = '' : log = "bld=#{lib.nil? ? bld : lib}-#{ittr}"
		cmd += "#{@source_dir}#{bld}/dist/bin/firefox -P #{@profile}bench #{page}\\?#{log} >&${logfd}"
		cmd_perf += "#{@source_dir}#{bld}/dist/bin/firefox -P #{@profile}bench #{page} >&${logfd}"

		if @do_bench || (ittr < 0 && @do_trace)
			puts "echo '#{cmd}' >&0"
			puts cmd
		end
		if(ittr == 0 && @do_perf)
			puts cmd_perf.gsub('-e', '-e cycles,instructions,cache-misses,branch-misses,page-faults,cs')
			puts cmd_perf.gsub('stat', 'record').gsub("#{@results_dir}/perf/", '').gsub('-e', '-F 500 --call-graph dwarf').gsub('.txt', '.data')
			puts "mv *.data #{@results_dir}/perf"
		end
	end

	def do_tests()
		puts "logf=#{@logs_dir}/#{@profile}bld.log"
		puts 'exec {logfd} >> ${logf}'
		@iters.times { |n| do_test('bld', n) }
		puts "echo 'end' >&0"
		puts ''

		@@libs.each do |lib|
			puts "logf=#{@logs_dir}/#{@profile}#{lib}.log"
			puts 'exec {logfd} >> ${logf}'
			@iters.times { |n| do_test('bld-rmalloc', n, lib + '-rmalloc') }
			puts "echo 'end #{lib}' >&0"
			puts ''
		end

		['rmalloc', 'hoard'].each do |lib|
			puts "logf=#{@logs_dir}/#{@profile}#{lib}-log.log"
			puts 'exec {logfd} >> ${logf}'
			puts 'du -h --max-depth=2 /ramdisk'
			do_test('bld-rmalloc', -1, lib + '-log')
			puts "mv ./max #{@results_dir}/trace/max-#{lib}.txt"
			puts "mv ./trace #{@results_dir}/trace/trace-#{lib}.txt"
			puts "echo 'end #{lib}-log' >&0"
			puts ''
		end

		puts 'kill `ps --no-header -C php -o pid`'
		puts "echo 'all done :D' >&0"
	end
end