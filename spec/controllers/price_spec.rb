require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /prices" do
    let(:response) { get "/prices" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Prices" }
  end
end
