#!/usr/bin/ruby

$stdout.reopen('render.sh', 'w')
$stdout.sync = true

require './do_test.rb'

test = Tester.new('render', 800)
test.do_tests()