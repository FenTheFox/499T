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
		
		p "php -S #{@@root} -t #{profile}bench -c php.ini"
		@phpid = Process.spawn("php -S #{@@root} -t #{profile}bench -c php.ini", [:out, :err] => ['logs/phplog', 'w'])
		@http = Net::HTTP.new('localhost', 8000)
	end

	def do_test(bld, lib = '')
		p [bld, lib]
		sleep 5
		fid = Process.spawn("../../source/firefox-#{bld}/dist/bin/firefox -foreground -P #{@profile}bench -new-window #{@@root}/index.php\\?bld=#{bld}#{lib}", [:out, :err] => ["logs/flog-#{bld}#{lib}", 'w'])
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

		@@libs.each do |l|
			ENV['LD_PRELOAD'] = '../../Replace-Libs/lib' + l + '.so'
			@iters.times { |n| do_test('bld-rmalloc', l) }
		end
		
		['hoard'].each do |l|
			ENV['LD_PRELOAD'] = '../../Replace-Libs/lib' + l + '-log.so'
			@iters.times do |n|
				do_test('bld-rmalloc', l + '-log')
				begin
					FileUtils.mv('./max', "../../results/firefox/#{@profile}/trace/max-#{l}#{n}")
					FileUtils.mv('./trace', "../../results/firefox/#{@profile}/trace/trace-#{l}#{n}")
				rescue Exception => e
					p "welp"
				end
			end
		end

		@timeout *= 10
		ENV['LD_PRELOAD'] = '../../Replace-Libs/librmalloc-log.so'
		@iters.times do |n|
			do_test('bld-rmalloc', 'default-log')
			begin
				FileUtils.mv('./max', "../../results/firefox/#{@profile}/trace/max-default#{n}")
				FileUtils.mv('./trace', "../../results/firefox/#{@profile}/trace/trace-default#{n}")
			rescue Exception => e
				p "welp"
			end
		end

		ENV['LD_PRELOAD'] = nil

		finish()
	end

	def finish()
		Process.kill('TERM', @phpid)
		Process.wait(@phpid)
	end
end