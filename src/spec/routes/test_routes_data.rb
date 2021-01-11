require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_api_keys
    get "/api_keys"
    assert last_response.body.include?("API Keys")
  end

  def test_import
    get "/import"
    assert last_response.body.include?("Import")
  end

  def test_ofx
    get "/ofx"
    assert last_response.body.include?("OFX")
  end

  def test_receipt
    get "/receipt"
    assert last_response.body.include?("Receipt")
  end
end
