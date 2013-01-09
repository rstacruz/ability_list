$:.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'ability_list'
require 'ostruct'

require File.expand_path('../minitest/should_syntax.rb', __FILE__)

class TestCase < MiniTest::Unit::TestCase

end
