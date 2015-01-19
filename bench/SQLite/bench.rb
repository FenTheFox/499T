#!/usr/bin/ruby

require 'fileutils'

def run_test(bld, log=nil)
  itrs = 30
  flags = '-q -s 8'
  schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
  queries = 'query1.sql query2.sql query2-1.sql query.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'
  log = log.nil? ? bld : log
  
  p [bld, log]
  
  pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{itrs} #{flags} #{schema} #{queries} > ../../results/sqlite/#{log}.txt")
  Process.wait(pid)
end

def mv_trace(bld)
	FileUtils.mv('./max-mmap', '../../results/sqlite/trace/maxmmap-' + bld)
	FileUtils.mv('./max-malloc', '../../results/sqlite/trace/maxmalloc-' + bld)
	# FileUtils.mv('./trace-mmap', '../../results/sqlite/trace/tracemmap-' + bld)
	# FileUtils.mv('./trace-malloc', '../../results/sqlite/trace/tracemalloc-' + bld)
end

run_test('sys')
run_test('zone')
run_test('mem3')
run_test('mem5')

run_test('mem3log')
mv_trace('mem3log')
run_test('mem5log')
mv_trace('mem5log')

['hoard', 'jexxmalloc', 'tlsf'].each do |l|
  ENV['DYLD_INSERT_LIBRARIES'] = '/Users/timm/499T/Replace-Libs/lib' + l + '.dylib'
  run_test('rmalloc', l)
  run_test('rmalloc-zone', l + '-zone')
end

['hoard-log', 'jexxmalloc-log'].each do |l|
  ENV['DYLD_INSERT_LIBRARIES'] = '/Users/timm/499T/Replace-Libs/lib' + l + '.dylib'
  run_test('rmalloc', l)
	mv_trace(l)
  run_test('rmalloc-zone', l + '-zone')
	mv_trace(l + '-zone')
end
ENV['DYLD_INSERT_LIBRARIES'] = nil