require_relative "../../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /tax/forms" do
    it "has a list of available tax forms" do
      response = get "/tax/forms"
      expect(response.status).to eq 200
    end
  end

  context "GET /tax/form/:unit/:form" do
    it "gets the specified form" do
      response = get "/tax/form/us/1040"
      expect(response.status).to eq 200
    end
  end
end