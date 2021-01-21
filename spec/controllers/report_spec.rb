require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /report" do
    let(:response) { get "/report" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Report" }
  end
end
