require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_budget
    get "/budget"
    assert last_response.body.include?("Budget")
  end
end
