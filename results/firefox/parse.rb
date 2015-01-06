#!/usr/bin/ruby

require 'csv'

bld = 0
zone = 0
hoard = 0
jemalloc = 0

bldc = 0.0
zonec = 0.0
hoardc = 0.0
jemallocc = 0.0

Dir.glob('js/*.txt') do |f|
	file = File.open(f)
	file.gets
	num = file.gets('ms').strip!.delete!('ms').to_i
  
	if(!f.index('zone').nil?)
    zone += num
		zonec += 1
  elsif(!f.index('hoard').nil?)
  	hoard += num
		hoardc += 1
  elsif(!f.index('jexxmalloc').nil?)
  	jemalloc += num
		jemallocc += 1
  else
    bld += num
		bldc += 1
  end
end

p 'js'
p "bld #{bld/bldc}"
p "zone #{zone/zonec}"
p "hoard #{hoard/hoardc}"
p "jemalloc #{jemalloc/jemallocc}"

bld = {}
zone = {}
hoard = {}
jemalloc = {}

Dir.glob('render/*.txt') do |f|
  CSV.foreach(f, col_sep: ': ') do |r|
    key = r[0].to_sym
    val = r[1].to_f
    if(!f.index('zone').nil?)
      zone[r[0]].nil? ? zone[key] = val : zone[key] += val
    elsif(!f.index('hoard').nil?)
    	hoard[r[0]].nil? ? hoard[key] = val : hoard[key] += val
    elsif(!f.index('jexxmalloc').nil?)
    	jemalloc[r[0]].nil? ? jemalloc[key] = val : jemalloc[key] += val
    else
      bld[r[0]].nil? ? bld[key] = val : bld[key] += val
    end
  end
end

p 'render'
total = 0
bld.each_value {|v| total += v}
p "bld #{total/bld.size}"

total = 0
zone.each_value {|v| total += v}
p "zone #{total/zone.size}"

total = 0
hoard.each_value {|v| total += v}
p "hoard #{total/hoard.size}"

total = 0
jemalloc.each_value {|v| total += v}
p "jemalloc #{total/jemalloc.size}"