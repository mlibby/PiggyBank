ENV['APP_ENV'] = 'test'

require "simplecov"
SimpleCov.start

require 'minitest'
require "minitest/autorun"
require 'rack/test'
require_relative "../server"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

end