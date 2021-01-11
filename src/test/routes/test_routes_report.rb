require_relative "../test_helper.rb"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def test_report
    get "/report"
    assert last_response.body.include?("Reporting")
  end
end
