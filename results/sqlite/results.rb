#!/usr/bin/ruby

require 'csv'

sys = {}
zone = {}
mem3 = {}
mem5 = {}
hoard = {}
hoard_zone = {}
jemalloc = {}
jemalloc_zone = {}
tlsf = {}
tlsf_zone = {}

sysc = 0
zonec = 0
mem3c = 0
mem5c = 0
hoardc = 0
hoard_zonec = 0
jemallocc = 0
jemalloc_zonec = 0
tlsfc = 0
tlsf_zonec = 0

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
		if(f.index('zone').nil?)
			hoard = parse(f)
			hoardc += 1
		else
			hoard_zone = parse(f)
			hoard_zonec += 1
		end
  elsif(!f.index('jexxmalloc').nil?)
		if(f.index('zone').nil?)
			jemalloc = parse(f)
			jemallocc += 1
		else
			jemalloc_zone = parse(f)
			jemalloc_zonec += 1
		end
  elsif(!f.index('tlsf').nil?)
		if(f.index('zone').nil?)
			tlsf = parse(f)
			tlsfc += 1
		else
			tlsf_zone = parse(f)
			tlsf_zonec += 1
		end
  else
    zone = parse(f)
		zonec += 1
  end
end

total = 0
sys.each_value {|v| total += v}
p "sys #{total/sysc}"

total = 0
zone.each_value {|v| total += v}
p "zone #{total/zonec}"

total = 0
mem3.each_value {|v| total += v}
p "mem3 #{total/mem3c}"

total = 0
mem5.each_value {|v| total += v}
p "mem5 #{total/mem5c}"

total = 0
hoard.each_value {|v| total += v}
p "hoard #{total/hoardc}"

total = 0
hoard_zone.each_value {|v| total += v}
p "hoard zone #{total/hoard_zonec}"

total = 0
jemalloc.each_value {|v| total += v}
p "jemalloc #{total/jemallocc}"

total = 0
jemalloc_zone.each_value {|v| total += v}
p "jemalloc zone #{total/jemalloc_zonec}"

total = 0
tlsf.each_value {|v| total += v}
p "tlsf #{total/tlsfc}"

total = 0
tlsf_zone.each_value {|v| total += v}
p "tlsf zone #{total/tlsf_zonec}"