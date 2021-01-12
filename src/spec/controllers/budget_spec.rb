require_relative "../spec_helper.rb"
require_relative "../../controllers/home.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /budget" do
    let(:response) { get "/budget" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Budget" }
  end
end
