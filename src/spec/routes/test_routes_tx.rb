require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_txs
    get "/txs"
    assert last_response.body.include?("Transactions")
  end
end
