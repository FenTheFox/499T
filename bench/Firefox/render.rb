#!/usr/bin/ruby

$stdout.reopen("render.sh", 'w')
$stdout.sync = true
$stderr.reopen($stdout)

require './do_test.rb'

test = Tester.new('render', 800, 7)
test.do_tests()