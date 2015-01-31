#!/usr/bin/ruby

require 'csv'
require 'pry'

bld = 0
hoard = 0
jemalloc = 0
nedmalloc = 0

bldc = 0.0
hoardc = 0.0
jemallocc = 0.0
nedmallocc = 0.0

Dir.glob('js/*.txt') do |f|
	file = File.open(f)
	file.gets
	num = file.gets('ms').strip!.delete!('ms').to_f
	
	if(!f.index('nedmalloc').nil?)
		nedmalloc += num
		nedmallocc += 1
	elsif(!f.index('hoard').nil?)
		hoard += num
		hoardc += 1
	elsif(!f.index('jemalloc').nil?)
		jemalloc += num
		jemallocc += 1
	else
		bld += num
		bldc += 1
	end
end

puts 'js'
puts "bld #{bld/bldc}"
puts "hoard #{hoard/hoardc}"
puts "jemalloc #{jemalloc/jemallocc}"
puts "nedmalloc #{nedmalloc/nedmallocc}"

bld = {}
hoard = {}
jemalloc = {}
nedmalloc = {}

bldc = {}
hoardc = {}
jemallocc = {}
nedmallocc = {}

Dir.glob('render/*.txt') do |f|
	CSV.foreach(f, col_sep: ': ') do |r|
		key = r[0].to_sym
		val = r[1].to_f
		
		# binding.pry
		if(!f.index('nedmalloc').nil?)
			nedmalloc[key].nil? ? nedmalloc[key] = val : nedmalloc[key] += val
			nedmallocc[key].nil? ? nedmallocc[key] = 1 : nedmallocc[key] += 1
		elsif(!f.index('hoard').nil?)
			hoard[key].nil? ? hoard[key] = val : hoard[key] += val
			hoardc[key].nil? ? hoardc[key] = 1 : hoardc[key] += 1
		elsif(!f.index('jemalloc').nil?)
			jemalloc[key].nil? ? jemalloc[key] = val : jemalloc[key] += val
			jemallocc[key].nil? ? jemallocc[key] = 1 : jemallocc[key] += 1
		else
			bld[key].nil? ? bld[key] = val : bld[key] += val
			bldc[key].nil? ? bldc[key] = 1 : bldc[key] += 1
		end
	end
end

# binding.pry

puts 'render'
total = 0
bld.each {|k,v| total += v/(bldc[k])}
puts "bld #{total}"

total = 0
hoard.each {|k,v| total += v/(hoardc[k])}
puts "hoard #{total}"

total = 0
jemalloc.each {|k,v| total += v/(jemallocc[k])}
puts "jemalloc #{total}"

total = 0
nedmalloc.each {|k,v| total += v/(nedmallocc[k])}
puts "nedmalloc #{total}"