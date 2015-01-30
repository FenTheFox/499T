#!/usr/bin/ruby

require 'csv'

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

Dir.glob('render/*.txt') do |f|
	CSV.foreach(f, col_sep: ': ') do |r|
		key = r[0].to_sym
		val = r[1].to_f
		if(!f.index('nedmalloc').nil?)
			nedmalloc[r[0]].nil? ? nedmalloc[key] = val : nedmalloc[key] += val
		elsif(!f.index('hoard').nil?)
			hoard[r[0]].nil? ? hoard[key] = val : hoard[key] += val
		elsif(!f.index('jemalloc').nil?)
			jemalloc[r[0]].nil? ? jemalloc[key] = val : jemalloc[key] += val
		else
			bld[r[0]].nil? ? bld[key] = val : bld[key] += val
		end
	end
end

puts 'render'
total = 0
bld.each_value {|v| total += v}
puts "bld #{total/bld.size}"

total = 0
hoard.each_value {|v| total += v}
puts "hoard #{total/hoard.size}"

total = 0
jemalloc.each_value {|v| total += v}
puts "jemalloc #{total/jemalloc.size}"

total = 0
nedmalloc.each_value {|v| total += v}
puts "nedmalloc #{total/nedmalloc.size}"