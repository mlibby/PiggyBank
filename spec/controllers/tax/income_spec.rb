require_relative "../../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /tax/data/income" do
    it "has an income form" do
      response = get "/tax/data/income"
      expect(response.status).to eq 200
    end
  end
  
  save_params = {
    _token: PiggyBank::App.token
  }

  context "POST /tax/data/income" do
    it "saves income data" do
      response = post "/tax/data/income", save_params
      expect(response.status).to eq 200
    end
  end
end

