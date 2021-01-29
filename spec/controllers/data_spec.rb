require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /commimportodities" do
    let(:response) { get "/import" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Import" }
  end

  context "get /receipt" do
    let(:response) { get "/receipt" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Receipt" }
  end
end
