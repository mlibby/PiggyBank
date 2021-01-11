require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_prices
    get "/prices"
    assert last_response.body.include?("Prices")
  end
end
