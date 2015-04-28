#!/usr/bin/ruby

require 'csv'
require 'pry'

class Results
	@@results = {
		default:     { js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 },
		hoard:       { js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 },
		jemalloc:    { js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 },
		# nedmalloc: { js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 }
	}

	@@traces = {
		default_js:     { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 },
		hoard_js:       { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 },
		default_render: { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 },
		hoard_render:   { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 }
	}

	def self.parse_js(file, key)
		File.open(file) do |fh|
			arr = []
			tmp = fh.to_a
			tmp.slice!(0, tmp.find_index { |l| l.index('Raw') })
			tmp.delete_if { |e| !e.start_with?("\t\t") }.each { |e| e.strip!.gsub!(/[urem: \[\]]/, '') }.each { |e| arr << e.split(',').map(&:to_i) }

			idx = @@results[key][:js].length
			for i in 0..(arr[0].length - 1)
				@@results[key][:js] << 0.0
				arr.each { |a| @@results[key][:js][idx+i] += a[i] }
			end
		end
	end

	def self.parse_render(file, key)
		idx = file.scan(/\d/)[0].to_i
		r = @@results[key][:render]
		r[idx] ||= 0.0

		CSV.foreach(file, col_sep: ": ") do |l|
			r[idx] += l[1].to_f
		end
	end

	def self.parse_trace(file, key)
		min = 100000
		in_use = 0
		mmap = 0
		arr = @@traces[key]
		CSV.foreach(file, col_sep: " ") do |l|
			next if (sz = l[1].to_i) == 0
			if(l[0] == 'malloc')
				binding.pry if sz == 0
				in_use += sz
				arr[:objs] += 1
				arr[:total_mem] += sz
				arr[:in_use] = in_use if arr[:in_use] < in_use
				arr[:max] = sz if arr[:max] < sz
				arr[:min] = sz if arr[:min] > sz
				arr[:ops] += 1
			elsif (l[0] == 'free')
				in_use -= sz
				arr[:ops] += 1
			elsif (l[0] == 'mmap')
				mmap += sz
				arr[:mmap] = mmap if mmap > arr[:mmap]
			elsif (l[0] == 'munmap')
				mmap -= sz
			end
		end
	end

	def self.calc_stats
		@@results.each do |k, v|
			js = v[:js]
			render = v[:render]

			js_mean = v[:js_mean] = js.reduce(:+)/js.length.to_f
			render_mean = v[:render_mean] = render.reduce(:+)/render.length.to_f

			tmp = 0
			js.each { |i| tmp += (i-js_mean)**2 }
			v[:js_stdev] = Math.sqrt(tmp/(js.length-1).to_f)
			tmp = 0
			render.each { |i| tmp += (i-render_mean)**2 }
			v[:render_stdev] = Math.sqrt(tmp/(render.length-1).to_f)
		end
	end

	def self.print_results
		calc_stats
		jf = File.new('js.csv', 'w')
		jsf = File.new('js_stats.csv', 'w')
		rf = File.new('render.csv', 'w')
		rsf = File.new('render_stats.csv', 'w')

		jf.puts 'allocator,runtime'
		jsf.puts 'allocator,mean,standard_dev'
		rf.puts 'allocator,runtime'
		rsf.puts 'allocator,mean,standard_dev'
		@@results.each do |k, v|
			for i in 0..(v[:js].length-1) do jf.puts "#{k},#{v[:js][i]}" end
			for i in 0..(v[:render].length-1) do rf.puts "#{k},#{v[:render][i]}" end
			jsf.puts "#{k},#{v[:js_mean]},#{v[:js_stdev]}"
			rsf.puts "#{k},#{v[:render_mean]},#{v[:render_stdev]}"
		end
	end
end

Dir.glob('js/*.txt') do |f|
	if(!f.index('bld').nil?)
		Results.parse_js(f, :default)
	elsif(!f.index('hoard').nil?)
		Results.parse_js(f, :hoard)
	elsif(!f.index('jemalloc').nil?)
		Results.parse_js(f, :jemalloc)
	elsif(!f.index('nedmalloc').nil?)
		Results.parse_js(f, :nedmalloc)
	end
end

Dir.glob('js/trace/*.txt') do |f|
	if(!f.index('rmalloc').nil?)
		Results.parse_trace(f, :default_js)
	elsif(!f.index('hoard').nil?)
		Results.parse_trace(f, :hoard_js)
	end
end

Dir.glob('render/*.txt') do |f|
	if(!f.index('bld').nil?)
		Results.parse_render(f, :default)
	elsif(!f.index('hoard').nil?)
		Results.parse_render(f, :hoard)
	elsif(!f.index('jemalloc').nil?)
		Results.parse_render(f, :jemalloc)
	elsif(!f.index('nedmalloc').nil?)
		Results.parse_render(f, :nedmalloc)
	end
end

Dir.glob('render/trace/*.txt') do |f|
	if(!f.index('rmalloc').nil?)
		Results.parse_trace(f, :default_render)
	elsif(!f.index('hoard').nil?)
		Results.parse_trace(f, :hoard_render)
	end
end

Results.print_results