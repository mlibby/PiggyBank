require_relative "../spec_helper.rb"
require_relative "../../controllers/home.rb"

describe PiggyBank do
  include Rack::Test::Methods

  let(:app) { PiggyBank.new }

  context "get /commodities" do
    let(:response) { get "/commodities" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Commodities" }
  end
end
