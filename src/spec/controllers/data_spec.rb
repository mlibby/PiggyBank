require_relative "../spec_helper.rb"
require_relative "../../controllers/home.rb"

describe PiggyBank do
  include Rack::Test::Methods

  let(:app) { PiggyBank.new }

  context "get /api_keys" do
    let(:response) { get "/api_keys" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "API Keys" }
  end

  context "get /commimportodities" do
    let(:response) { get "/import" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Import" }
  end

  context "get /ofx" do
    let(:response) { get "/ofx" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "OFX" }
  end

  context "get /receipt" do
    let(:response) { get "/receipt" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Receipt" }
  end
end
