require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_oink
    get "/"
    assert last_response.body.include?("Oink!")
  end
end
