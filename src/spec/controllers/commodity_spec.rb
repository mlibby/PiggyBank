require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  let(:app) { PiggyBank::App.new }

  before(:example) do
    PiggyBank::Commodity.truncate
    PiggyBank::Commodity.create name: "USD",
                                type: PiggyBank::Commodity::COMMODITY_TYPE[:currency],
                                description: "US Dollar",
                                ticker: "USD",
                                fraction: 100
  end

  context "get /commodities" do
    let(:response) { get "/commodities" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Commodities" }
  end

  context "get /commodity/new" do
    let(:response) { get "/commodity/new" }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "New Commodity" }
    it { expect(response.body).to include "<form method='POST'>" }
  end

  context "get /commodity/edit/#" do
    let(:response) {
      cid = PiggyBank::Commodity.where(name: "USD").single_record.commodity_id
      get "/commodity/edit/#{cid}"
    }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Edit Commodity" }

    it "has an edit form" do
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: {name: "_token", type: "hidden"}
      end
    end
  end
end
