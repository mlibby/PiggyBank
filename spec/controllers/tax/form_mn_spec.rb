require_relative "../../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /tax/form/mn/m1" do
    it "gets the M1 form as a PDF" do
      response = get "/tax/form/mn/m1"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/form/mn/m1c" do
    it "gets the M1C form as a PDF" do
      response = get "/tax/form/mn/m1c"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/form/mn/m1m" do
    it "gets the M1M form as a PDF" do
      response = get "/tax/form/mn/m1m"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/mn/m1ma" do
    it "gets the M1MA as a PDF" do
      response = get "/tax/form/mn/m1ma"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/mn/m1sa" do
    it "gets the M1SA as a PDF" do
      response = get "/tax/form/mn/m1sa"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/mn/m1w" do
    it "gets the M1W as a PDF" do
      response = get "/tax/form/mn/m1w"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end

  context "GET /tax/forms/mn/m1529" do
    it "gets the m1529 as a PDF" do
      response = get "/tax/form/mn/m1529"
      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/pdf"
    end
  end
end
