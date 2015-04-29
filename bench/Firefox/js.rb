#!/usr/bin/ruby

$stdout.reopen('js.sh', 'w')
$stdout.sync = true

require './do_test.rb'

test = Tester.new('js', './jsbench/index.html')
test.do_tests()