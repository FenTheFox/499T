#!/usr/bin/ruby

require './do_test.rb'

test = Tester.new('renderbench', 700, 10)
test.do_tests()