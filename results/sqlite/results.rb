#!/usr/bin/ruby

require 'csv'

sys = {}
mem3 = {}
mem5 = {}
hoard = {}
jemalloc = {}
nedmalloc = {}

sysc = 0
mem3c = 0
mem5c = 0
hoardc = 0
jemallocc = 0
nedmallocc = 0

def parse(file)
	type = {}
	CSV.foreach(file, col_sep: ":\t\t") do |r|
		k = r[0].to_sym
		v = r[1].to_i
		type[k].nil? ? type[k] = v : type[k] += v
	end
	return type
end

Dir.glob('*.txt') do |f|
	if(!f.index('sys').nil?)
		sys = parse(f)
		sysc += 1
	elsif(!f.index('mem3').nil?)
		mem3 = parse(f)
		mem3c += 1
	elsif(!f.index('mem5').nil?)
		mem5 = parse(f)
		mem5c += 1
	elsif(!f.index('hoard').nil?)
		hoard = parse(f)
		hoardc += 1
	elsif(!f.index('jemalloc').nil?)
		jemalloc = parse(f)
		jemallocc += 1
  elsif(!f.index('nedmalloc').nil?)
		nedmalloc = parse(f)
		nedmallocc += 1
  end
end

total = 0
sys.each_value {|v| total += v}
puts "sys		#{total/sysc}"

total = 0
mem3.each_value {|v| total += v}
puts "mem3		#{total/mem3c}"

total = 0
mem5.each_value {|v| total += v}
puts "mem5		#{total/mem5c}"

total = 0
hoard.each_value {|v| total += v}
puts "hoard		#{total/hoardc}"

total = 0
jemalloc.each_value {|v| total += v}
puts "jemalloc	#{total/jemallocc}"

total = 0
nedmalloc.each_value {|v| total += v}
puts "nedmalloc	#{total/nedmallocc}"