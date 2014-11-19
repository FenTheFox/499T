#!/usr/bin/ruby

require 'timeout'

@args = '-P jsbench 192.168.1.17/render'

def do_test(bld)
  puts 'starting ' + bld
  pid = Process.spawn('~/499T/source/firefox-' + bld + '/dist/Firefox.app/Contents/MacOS/firefox ' + @args )
  begin
    Timeout.timeout(10 * 60) do
      Process.wait(pid)
    end
  rescue Timeout::Error
    Process.kill('TERM', pid)
    puts 'killed'
  end
end

do_test('bld')
do_test('bld-zone')

`export DYLD_FORCE_FLAT_NAMESPACE=1`

`export DYLD_INSERT_LIBRARIES=~/499T/Replace-Libs/libhoard.dylib:~/499T/Replace-Libs/libreplace_malloc.dylib`
do_test('bld-rmalloc')

`export DYLD_INSERT_LIBRARIES=~/499T/Replace-Libs/libtlsf.dylib:~/499T/Replace-Libs/libreplace_malloc.dylib`
do_test('bld-rmalloc')

`export DYLD_FORCE_FLAT_NAMESPACE=`
`export DYLD_INSERT_LIBRARIES=`