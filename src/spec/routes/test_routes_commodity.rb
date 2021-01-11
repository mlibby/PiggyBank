require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_commodities
    get "/commodities"
    assert last_response.body.include?("Commodities")
  end
end
