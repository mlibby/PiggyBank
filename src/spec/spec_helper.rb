require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "rspec"
require "rack/test"

ENV["APP_ENV"] = "TEST"
require_relative "../piggybank_app.rb"
