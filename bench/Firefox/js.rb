#!/usr/bin/ruby

require './do_test.rb'

test = Tester.new('jsbench', 700, 5)
test.do_tests()