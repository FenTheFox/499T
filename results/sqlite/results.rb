#!/usr/bin/ruby

require 'csv'
require 'pry'

itrs = 30

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
	CSV.foreach(file, col_sep: ":\t") do |r|
		k = r[0].to_sym
		v = r[1].to_i
		type[k].nil? ? type[k] = v : type[k] += v
	end
	return type
end

def print_results(h, c)
	h.each do |k,v|
		if(k.to_s.index('Avg').nil?)
			puts "#{k} #{(v/(c*itrs)).to_i}"
		else
			puts "Total #{(v/c).to_i}"
		end
	end
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

# binding.pry

puts 'sys'
print_results(sys, sysc)

puts 'mem3'
print_results(mem3, mem3c)

puts 'mem5'
print_results(mem5, mem5c)

puts 'hoard'
print_results(hoard, hoardc)

puts 'jemalloc'
print_results(jemalloc, jemallocc)

puts 'nedmalloc'
print_results(nedmalloc, nedmallocc)