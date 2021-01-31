require_relative "../../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /tax/data" do
    it "has a list of data forms" do
      response = get "/tax/forms"
      expect(response.status).to eq 200
    end
  end
end