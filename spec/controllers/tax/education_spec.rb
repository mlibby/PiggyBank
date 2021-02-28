require_relative "../../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /tax/data/education" do
    it "has a page for education expenses" do
      response = get "/tax/data/education"
      expect(response.status).to eq 200
    end
  end
  
  save_params = {
    _token: PiggyBank::App.token
  }
  
  context "POST /tax/data/education" do
    it "saves education data" do
      response = post "/tax/data/education", save_params
      expect(response.status).to eq 200
    end
  end
end
