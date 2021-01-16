require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /commodities" do
    let(:response) { get "/commodities" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Commodities" }
  end

  context "get /commodity/new" do
    let(:response) { get "/commodity/new" }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "New Commodity" }
    it { expect(response.body).to include "<form method='POST'>" }
  end
end
