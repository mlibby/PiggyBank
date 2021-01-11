require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "rspec"
require "rack/test"
require_relative "../piggybank.rb"
