require_relative "../spec_helper.rb"

describe PiggyBank do
  include Rack::Test::Methods

  let(:app) { PiggyBank.new }

  context "get /css/main.css" do
    let(:response) { get "/css/main.css" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "font-family" }
  end
end
