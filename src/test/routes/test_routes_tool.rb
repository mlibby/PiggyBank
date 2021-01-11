require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_mortgage
    get "/tool/mortgage"
    assert last_response.body.include?("Mortgage")
  end
end
