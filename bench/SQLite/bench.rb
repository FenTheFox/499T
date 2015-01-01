#!/usr/bin/ruby

def run_test(bld, log=nil)
  itrs = 30
  flags = '-q -s 8'
  schema = 'songdb.sql albums2.sql artists2.sql songs2.sql tags2.sql users2.sql usersongplays2.sql usersongratings2.sql'
  queries = 'query1.sql query2.sql query2-1.sql query.sql query3.sql query4.sql query5.sql query5-1.sql query6.sql query6-1.sql query7.sql query7-1.sql query8.sql query9.sql query10.sql'
  log = log.nil? ? bld : log
  
  p log
  p "../../bin/sqlite/sqlite3-#{bld} #{itrs} #{flags} #{schema} #{queries}"
  
  pid = Process.spawn("../../bin/sqlite/sqlite3-#{bld} #{itrs} #{flags} #{schema} #{queries}")
  Process.wait(pid)
end

run_test('test', 'system')
run_test('mem3-test')
run_test('mem5-test')

ENV['DYLD_FORCE_FLAT_NAMESPACE'] = '1'

libs = ['hoard', 'tlsf']
libs.each do |l|
  ENV['DYLD_INSERT_LIBRARIES'] = '/Users/timm/499T/Replace-Libs/lib' + l + '.dylib'
  run_test('test', l)
end

ENV['DYLD_FORCE_FLAT_NAMESPACE'] = nil
ENV['DYLD_INSERT_LIBRARIES'] = nil