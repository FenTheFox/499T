#!/usr/bin/ruby

$stdout.reopen("js.sh", 'w')
$stdout.sync = true

require './do_test.rb'

test = Tester.new('js', 800, 3)
test.do_tests()