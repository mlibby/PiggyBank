require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  context "get /css/main.css" do
    let(:response) { get "/css/main.css" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "font-family" }
  end

  context "is running" do
    it { expect(PiggyBank::App.token).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/) }
  end

  context "dangerous request without _token" do
    it "responds to DELETE with 403" do
      response = delete "/commodity/1"
      expect(response.status).to eq 403
    end

    it "responds to POST with 403" do
      response = post "/commodity"
      expect(response.status).to eq 403
    end

    it "responds to PUT with 403" do
      response = put "/commodity/1"
      expect(response.status).to eq 403
    end
  end
end
