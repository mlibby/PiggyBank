require_relative "../spec_helper.rb"
require_relative "../../controllers/home.rb"

describe PiggyBank do
  include Rack::Test::Methods

  let(:app) { PiggyBank.new }

  context "get /settings" do
    let(:response) { get "/settings" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Settings" }
  end
end
