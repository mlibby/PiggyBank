ENV['APP_ENV'] = 'test'

require 'minitest'
require 'rack/test'
require_relative "../server"

class HelloWorldTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_says_hello_to_a_person
    get '/'
    assert last_response.body.include?('Oink!')
  end

  def test_accounts
    get '/accounts'
    assert last_response.body.include?("aAccounts")
  end
end