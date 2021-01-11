require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_settings
    get "/settings"
    assert last_response.body.include?("Settings")
  end
end
