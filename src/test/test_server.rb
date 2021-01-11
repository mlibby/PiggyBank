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

  def test_oink
    get '/'
    assert last_response.body.include?('Oink!')
  end

  def test_accounts
    get '/accounts'
    assert last_response.body.include?("Accounts")
  end
end