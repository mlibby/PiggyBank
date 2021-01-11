require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_accounts
    get "/accounts"
    assert last_response.body.include?("Accounts")
  end
end
