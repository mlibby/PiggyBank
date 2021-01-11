require_relative "../spec_helper.rb"

describe PiggyBank do
  include Rack::Test::Methods

  let(:app) { PiggyBank.new }

  context "get /report" do
    let(:response) { get "/report" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Report" }
  end
end
