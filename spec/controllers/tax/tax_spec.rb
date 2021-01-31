require_relative "../../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /tax/data/tax" do
    it "has a tax form" do
      response = get "/tax/data/tax"
      expect(response.status).to eq 200
    end
  end
  
  save_params = {
    _token: PiggyBank::App.token
  }
  
  context "POST /tax/data/tax" do
    it "saves deductions data" do
      response = post "/tax/data/tax", save_params
      expect(response.status).to eq 200
    end
  end
end

