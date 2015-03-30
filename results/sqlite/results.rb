#!/usr/bin/ruby

require 'csv'
require 'pry'

class Results
	@@results = {
		sys:		{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem3:		{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem3_kb:	{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem3_mb:	{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem5:		{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem5_kb:	{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		mem5_mb:	{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		hoard:	{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		jemalloc:	{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 },
		nedmalloc:	{ setup: [], create: [], query: [], total: [], create_mean: 0, query_mean: 0, total_mean: 0, create_stdev: 0, query_stdev: 0, total_stdev: 0 }
	}

	# These are based off of the output of the c++ benchmark
	@@setup = 'Setup'
	@@create = 'Schema'
	@@query = 'Query'
	@@total = ''

	def self.parse(file, key)
		CSV.foreach(file, col_sep: ":\t") do |r|
			k = case r[0]
			when @@setup then :setup
			when @@create then :create
			when @@query then :query
			end
			@@results[key][k] << r[1].to_i if !k.nil?
		end
	end

	def self.calc_stats
		@@results.each do |k, v|
			s = v[:setup]
			c = v[:create]
			q = v[:query]
			t = v[:total]
			for i in 0..(s.length-1) do t << s[i] + c[i] + q[i] end if @@total.empty?

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

		rf.puts 'allocator,create,query,total'
		@@results.each do |k, v|
			s = v[:setup]
			c = v[:create]
			q = v[:query]
			for i in 0..(s.length-1)
				rf.puts "#{k},#{c[i]},#{q[i]},#{s[i] + c[i] + q[i]}"
				v[:total_mean] += s[i] + c[i] + q[i]
			end
			v[:create_mean] = c.reduce(:+)/c.length
			v[:query_mean] = q.reduce(:+)/q.length
			v[:total_mean] = v[:total_mean]/q.length
		end

		sf.puts 'allocator,create_mean,query_mean,total_mean,create_stdev,query_stdev,total_stdev'
		@@results.each do |k, v|
			cm = v[:create_mean]
			qm = v[:query_mean]
			tm = v[:total_mean]
			sf.puts "#{k},#{v[:create_mean]},#{v[:query_mean]},#{v[:total_mean]},#{v[:create_stdev]},#{v[:query_stdev]},#{v[:total_stdev]},"
		end
	end
end

Dir.glob('*.txt') do |f|
	next if !f.index('perf').nil?
	if(!f.index('sys').nil?)
		Results.parse(f, :sys)
	elsif(!f.index('mem3').nil?)
		if(!f.index('kb').nil?)
			Results.parse(f, :mem3_kb)
		elsif(!f.index('mb').nil?)
			Results.parse(f, :mem3_mb)
		else
			Results.parse(f, :mem3)
		end
	elsif(!f.index('mem5').nil?)
		if(!f.index('kb').nil?)
			Results.parse(f, :mem5_kb)
		elsif(!f.index('mb').nil?)
			Results.parse(f, :mem5_mb)
		else
			Results.parse(f, :mem5)
		end
	elsif(!f.index('hoard').nil?)
		Results.parse(f, :hoard)
	elsif(!f.index('jemalloc').nil?)
		Results.parse(f, :jemalloc)
	elsif(!f.index('nedmalloc').nil?)
		Results.parse(f, :nedmalloc)
	end
end

Results.print_results