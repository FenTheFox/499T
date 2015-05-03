#!/usr/bin/ruby

require 'csv'
require 'pry'

class Results
	@@results = {
		sys:       { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem3_32:   { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem3_128:  { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem5_32:   { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem5_128:  { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		hoard:     { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		jemalloc:  { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		nedmalloc: { create_runtime: [], query_runtime: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 }
	}

	@@traces = {
		mem3_32:  { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 },
		mem3_128: { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 },
		mem5_32:  { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 },
		mem5_128: { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 },
		hoard:    { objs: 0, total_mem: 0, mmap: 0, in_use: 0, max: 0, min: 100000, average: 0, ops: 0 }
	}

	# These are based off of the output of the c++ benchmark
	@@create = 'Schema'
	@@query = 'Query'
	@@total = ''

	def self.parse(file, key)
		CSV.foreach(file, col_sep: ":\t") do |r|
			k = case r[0]
			when @@create then :create_runtime
			when @@query then :query_runtime
			end
			@@results[key][k] << r[1].to_i if !k.nil?
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
			c = v[:create_runtime]
			q = v[:query_runtime]
			t = v[:total]
			for i in 0..(c.length-1) do t << (c[i] + q[i]) end if @@total.empty?

			cm = v[:create_mean] = c.reduce(:+)/c.length.to_f
			qm = v[:query_mean] = q.reduce(:+)/q.length.to_f
			tm = v[:total_mean] = t.reduce(:+)/t.length.to_f

			tmp = 0
			c.each { |i| tmp += (i-cm)**2 }
			v[:create_stdev] = Math.sqrt(tmp/(c.length-1).to_f)
			tmp = 0
			q.each { |i| tmp += (i-qm)**2 }
			v[:query_stdev] = Math.sqrt(tmp/(q.length-1).to_f)
			tmp = 0
			t.each { |i| tmp += (i-tm)**2 }
			v[:total_stdev] = Math.sqrt(tmp/(t.length-1).to_f)
		end
	end

	def self.print_results
		calc_stats
		rf = File.new('results.csv', 'w')
		sf = File.new('stats.csv', 'w')
		af = File.new('alloc.csv', 'w')

		rf.puts 'allocator,create,query,total'
		sf.puts 'allocator,create_mean,query_mean,total_mean,create_stdev,query_stdev,total_stdev'
		af.puts 'allocator,objs,total_mem,in_use,average,ops'
		@@results.each do |k, v|
			for i in 0..(v[:create_runtime].length-1)
				rf.puts "#{k},#{v[:create_runtime][i]},#{v[:query_runtime][i]},#{v[:total][i]}"
			end
			sf.puts "#{k},#{v[:create_mean]},#{v[:query_mean]},#{v[:total_mean]},#{v[:create_stdev]},#{v[:query_stdev]},#{v[:total_stdev]}"
		end
		@@traces.each do |k, v|
			af.puts "#{k},#{v[:objs]},#{v[:total_mem]},#{v[:in_use]},#{v[:average]},#{v[:ops]}"
		end
	end
end

Dir.glob('*.txt') do |f|
	if(!f.index('sys').nil?)
		Results.parse(f, :sys)
	elsif(!f.index('hoard').nil?)
		Results.parse(f, :hoard)
	elsif(!f.index('jemalloc').nil?)
		Results.parse(f, :jemalloc)
	elsif(!f.index('nedmalloc').nil?)
		Results.parse(f, :nedmalloc)
	elsif(!f.index('mem3').nil?)
		if(!f.index('32').nil?)
			Results.parse(f, :mem3_32)
		else
			Results.parse(f, :mem3_128)
		end
	elsif(!f.index('mem5').nil?)
		if(!f.index('32').nil?)
			Results.parse(f, :mem5_32)
		else
			Results.parse(f, :mem5_128)
		end
	end
end

Dir.glob('trace/*.txt') do |f|
	if(!f.index('sys').nil?)
		Results.parse_trace(f, :sys)
	elsif(!f.index('hoard').nil?)
		Results.parse_trace(f, :hoard)
	elsif(!f.index('jemalloc').nil?)
		Results.parse_trace(f, :jemalloc)
	elsif(!f.index('nedmalloc').nil?)
		Results.parse_trace(f, :nedmalloc)
	elsif(!f.index('mem3').nil?)
		if(!f.index('32').nil?)
			Results.parse_trace(f, :mem3_32)
		else
			Results.parse_trace(f, :mem3_128)
		end
	elsif(!f.index('mem5').nil?)
		if(!f.index('32').nil?)
			Results.parse_trace(f, :mem5_32)
		else
			Results.parse_trace(f, :mem5_128)
		end
	end
end

Results.print_results