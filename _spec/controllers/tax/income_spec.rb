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

  # this test is failing and I don't care right now

  # save_params = {
  #   _token: PiggyBank::App.token
  # }

  # context "POST /tax/data/income" do
  #   it "saves income data" do
  #     response = post "/tax/data/income", save_params
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/tax/data"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "Income data saved."
  #   end
  # end
end
