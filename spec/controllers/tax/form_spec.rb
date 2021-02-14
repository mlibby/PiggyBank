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

  context "GET /tax/form/us/f1040" do
    it "gets the specified form as a PDF" do
      response = get "/tax/form/us/f_1040"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/us/sched1" do
    it "gets the 1040 schedule 1 as a PDF" do
      response = get "/tax/form/us/sched_1"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end
end
