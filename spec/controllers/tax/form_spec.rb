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

  context "GET /tax/form/us/form_1040" do
    it "gets the specified form as a PDF" do
      response = get "/tax/form/us/form_1040"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/form/us/form_8283" do
    it "gets the specified form as a PDF" do
      response = get "/tax/form/us/form_8283"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/form/us/form_8889" do
    it "gets the specified form as a PDF" do
      response = get "/tax/form/us/form_8889"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/us/sched_1" do
    it "gets the 1040 schedule 1 as a PDF" do
      response = get "/tax/form/us/sched_1"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/us/sched_3" do
    it "gets the 1040 schedule 3 as a PDF" do
      response = get "/tax/form/us/sched_3"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/us/sched_e" do
    it "gets the 1040 schedule E as a PDF" do
      response = get "/tax/form/us/sched_e"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/us/sched_a" do
    it "gets the 1040 schedule A as a PDF" do
      response = get "/tax/form/us/sched_a"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end
end
