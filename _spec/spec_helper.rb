require "bigdecimal"
alias _d BigDecimal

require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "rspec"
require "rspec-html-matchers"
require "rack/test"

RSpec.configure do |config|
  config.include RSpecHtmlMatchers
end

ENV["APP_ENV"] = "TEST"
require_relative "../src/piggybank_app.rb"
require_relative "seeds/seed_db"

def flash
  last_request.env["rack.session"]["flash"]
end
