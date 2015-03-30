#!/usr/bin/ruby

require 'csv'
require 'pry'

class Results
	@@results = {
		default:		{ js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 },
		hoard:		{ js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 },
		jemalloc:	{ js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 },
		nedmalloc:	{ js: [], render: [], js_mean: 0, render_mean: 0, js_stdev: 0, render_stdev: 0 }
	}

	# :( probably needs to actually go through and get the raw data
	def self.parse_js(file, key)
		File.open(file) do |f|
			f.gets
			@@results[key][:js] << f.gets('ms').strip!.delete!('ms').to_f
		end
	end

	def self.parse_render(file, key)
		idx = @@results[key][:render].length
		r = @@results[key][:render] << 0.0

		CSV.foreach(file, col_sep: ": ") do |l|
			r[idx] += l[1].to_f
		end
		# binding.pry
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
	if(!f.index('nedmalloc').nil?)
		Results.parse_js(f, :nedmalloc)
	elsif(!f.index('hoard').nil?)
		Results.parse_js(f, :hoard)
	elsif(!f.index('jemalloc').nil?)
		Results.parse_js(f, :jemalloc)
	elsif(!f.index('bld').nil?)
		Results.parse_js(f, :default)
	end
end

Dir.glob('render/*.txt') do |f|
	if(!f.index('nedmalloc').nil?)
		Results.parse_render(f, :nedmalloc)
	elsif(!f.index('hoard').nil?)
		Results.parse_render(f, :hoard)
	elsif(!f.index('jemalloc').nil?)
		Results.parse_render(f, :jemalloc)
	elsif(!f.index('bld').nil?)
		Results.parse_render(f, :default)
	end
end

# binding.pry

Results.print_results