#!/usr/bin/ruby

require 'timeout'
require 'net/http'
require 'fileutils'

class Tester
	@@root = 'localhost:8000'
	@@libs = ['hoard', 'jexxmalloc']
	
	def initialize (profile, timeout, iters)
		@profile = profile
		@timeout = timeout
		@iters = iters
		
    p "php -S #{@@root} -t #{profile}bench -c php.ini"
		@phpid = Process.spawn("php -S #{@@root} -t #{profile}bench -c php.ini", [:out, :err] => ['logs/phplog', 'w'])
		@http = Net::HTTP.new('localhost', 8000)
	end

	def do_test(bld, lib = '')
		p [bld, lib]
    sleep 5
		fid = Process.spawn("/Users/Timm/499T/source/firefox-#{bld}/dist/Firefox.app/Contents/MacOS/firefox -foreground -P #{@profile}bench #{@@root}/index.php\\?bld=#{bld}#{lib}", [:out, :err] => ["logs/flog-#{bld}#{lib}", 'w'])
		@http.get("/index.php?fid=#{fid}")
		begin
			Timeout.timeout(@timeout) { Process.wait(fid) }
		rescue Timeout::Error
			Process.kill('TERM', fid)
			puts 'killed :('
		end
	end
	
	def do_tests()
		@iters.times { |n| do_test('bld') }
		@iters.times { |n| do_test('bld-zone') }

		@@libs.each do |l|
			ENV['DYLD_INSERT_LIBRARIES'] = '/Users/timm/499T/Replace-Libs/lib' + l + '.dylib:/Users/timm/499T/Replace-Libs/librmalloc.dylib'
			@iters.times { |n| do_test('bld-rmalloc', l) }
		end
		
		@@libs.each do |l|
			ENV['DYLD_INSERT_LIBRARIES'] = '/Users/timm/499T/Replace-Libs/lib' + l + '-log.dylib:/Users/timm/499T/Replace-Libs/librmalloc.dylib'
			@iters.times do |n|
				do_test('bld-rmalloc', l + '-log')
				FileUtils.mv('./max-mmap', "../../results/firefox/#{@profile}/trace/maxmmap-#{l}#{n}")
				FileUtils.mv('./max-malloc', "../../results/firefox/#{@profile}/trace/maxmalloc-#{l}#{n}")
				# FileUtils.mv('./trace-mmap', "../../results/firefox/#{@profile}/trace/tracemmap-#{l}#{n}")
				# FileUtils.mv('./trace-malloc', "../../results/firefox/#{@profile}/trace/tracemalloc-#{l}#{n}")
			end
		end

		@timeout *= 10
		ENV['DYLD_INSERT_LIBRARIES'] = '/Users/timm/499T/Replace-Libs/librmalloc-log.dylib'
		@iters.times do |n|
			do_test('bld-rmalloc', 'default-log')
			FileUtils.mv('./max-mmap', "../../results/firefox/#{@profile}/trace/maxmmap-default#{n}")
			FileUtils.mv('./max-malloc', "../../results/firefox/#{@profile}/trace/maxmalloc-default#{n}")
		end

		ENV['DYLD_INSERT_LIBRARIES'] = nil

    finish()
	end

	def finish()
		Process.kill('TERM', @phpid)
		Process.wait(@phpid)
	end
end