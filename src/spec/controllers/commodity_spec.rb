require "uri"
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

  context "GET /commodities" do
    let(:response) { get "/commodities" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Commodities" }
  end

  context "GET /commodity" do
    let(:response) { get "/commodity" }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "New Commodity" }
    it "has a form" do
      expect(response.body).to have_tag "form", with: {
                                                  method: "POST",
                                                  action: "/commodity",
                                                }
    end
  end

  context "GET /commodity/:id" do
    let(:response) {
      cid = PiggyBank::Commodity.where(name: "USD").single_record.commodity_id
      get "/commodity/#{cid}"
    }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to match /Commodity \d+/ }
  end

  context "GET /commodity/:id?edit" do
    let(:response) {
      cid = PiggyBank::Commodity.where(name: "USD").single_record.commodity_id
      get "/commodity/#{cid}?edit"
    }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Edit Commodity" }

    it "has an edit form" do
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "option", seen: "1/100 (123.12)", with: { value: "100", selected: "selected" }
        with_tag "option", seen: "Currency", with: { value: "1", selected: "selected" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
      end
    end
  end

  context "GET /commodity/:id?delete" do
    let(:response) {
      cid = PiggyBank::Commodity.where(name: "USD").single_record.commodity_id
      get "/commodity/#{cid}?delete"
    }

    it "has a delete confirmation form" do
      expect(response.body).to include "Delete Commodity?"
      expect(response.status).to eq 200
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
      end
    end
  end

  context "POST /commodity" do
    let(:response) {
      params = {
        _token: PiggyBank::App.token,
        type: 1,
        name: "FOO",
        description: "Foo Bar",
        ticker: "FOO",
        fraction: 1000,
      }
      post "/commodity", params
    }

    it "creates a new commodity" do
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/commodities"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Commodity 'FOO' created."

      c = PiggyBank::Commodity.where(name: "FOO").single_record
      expect(c.class).to eq PiggyBank::Commodity
    end
  end

  context "POST /commodity with invalid token" do
    # TODO: do not allow create with invalid token
  end

  context "PUT /commodity/:id" do
    let(:response) do
      usd = PiggyBank::Commodity.where(name: "USD").single_record
      params = {
        _token: PiggyBank::App.token,
        name: "USB",
        type: 2,
        description: "Universal Serial Bus",
        ticker: "USB",
        fraction: 1,
      }
      put "/commodity/#{usd.commodity_id}", params
    end

    it "updates the DB" do
      expect(response.status).to eq 200
      expect(response.body).to match /Commodity \d+/

      usb = PiggyBank::Commodity.where(name: "USB").single_record
      expect(usb.name).to eq "USB"
      expect(usb.description).to eq "Universal Serial Bus"
      expect(usb.ticker).to eq "USB"
      expect(usb.type).to eq 2
      expect(usb.fraction).to eq 1
    end
  end

  # TODO: do not allow update without valid token

  # TODO: do not allow update with version mismatch

  context "DELETE /commodity/:id" do
    let(:response) do
      usd = PiggyBank::Commodity.where(name: "USD").single_record
      delete "/commodity/#{usd.commodity_id}", { _token: PiggyBank::App.token }
    end

    it "deletes the commodity" do
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/commodities"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Commodity 'USD' deleted."
    end
  end

  # TODO: do not allow DELETE if token missing/changed

  # TODO: do not allow DELETE with version mismatch
end
