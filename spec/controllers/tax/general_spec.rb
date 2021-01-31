require_relative "../../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /tax/data/general" do
    it "has a general form" do
      response = get "/tax/data/general"
      expect(response.status).to eq 200
    end
  end

  save_params = {
    _token: PiggyBank::App.token
  }

  context "POST /tax/data/general" do
    it "saves general data" do
      response = post "/tax/data/general", save_params
      expect(response.status).to eq 200
    end
  end
end

