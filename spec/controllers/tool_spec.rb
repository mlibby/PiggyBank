require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /tool/mortgage" do
    let(:response) { get "/tool/mortgage" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Mortgage" }
  end
end
