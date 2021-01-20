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
      cid = PiggyBank::Commodity.find(name: "USD").commodity_id
      get "/commodity/#{cid}?edit"
    }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Edit Commodity" }

    it "has an edit form" do
      version = PiggyBank::Commodity.find(name: "USD").version
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "option", seen: "1/100 (123.12)", with: { value: "100", selected: "selected" }
        with_tag "option", seen: "Currency", with: { value: "1", selected: "selected" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
        with_tag "input", with: { name: "version", type: "hidden", value: version }
      end
    end
  end

  context "GET /commodity/:id?delete" do
    let(:response) {
      cid = PiggyBank::Commodity.where(name: "USD").single_record.commodity_id
      get "/commodity/#{cid}?delete"
    }

    it "has a delete confirmation form" do
      usd = PiggyBank::Commodity.find(name: "USD")
      expect(response.body).to include "Delete Commodity?"
      expect(response.status).to eq 200
      action = "/commodity/#{usd.commodity_id}"
      expect(response.body).to have_tag("form", with: { method: "POST", action: action }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
        with_tag "input", with: { name: "version", type: "hidden", value: usd.version }
      end
    end
  end

  def create_params
    {
      _token: PiggyBank::App.token,
      type: 1,
      name: "FOO",
      description: "Foo Bar",
      ticker: "FOO",
      fraction: 1000,
    }
  end

  context "POST /commodity" do
    let(:response) {
      post "/commodity", create_params
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
    let(:response) {
      params = create_params
      params[:_token] = "bad token"
      post "/commodity", params
    }

    it "politely refuses to create" do
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "New Commodity"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
    end
  end

  def update_params(existing)
    {
      _token: PiggyBank::App.token,
      name: "USB",
      type: 2,
      description: "Universal Serial Bus",
      ticker: "USB",
      fraction: 1,
      version: existing.version,
    }
  end

  context "PUT /commodity/:id with valid params" do
    let(:response) do
      usd = PiggyBank::Commodity.where(name: "USD").single_record
      put "/commodity/#{usd.commodity_id}", update_params(usd)
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

  context "PUT /commodity/:id with invalid token" do
    let(:response) {
      usd = PiggyBank::Commodity.where(name: "USD").single_record
      params = update_params(usd)
      params[:_token] = "bad token"
      put "/commodity/#{usd.commodity_id}", params
    }

    it "politely refuses to update" do
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Edit Commodity"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
    end
  end

  context "PUT /commodity/:id with version mismatch" do
    let(:response) {
      usd = PiggyBank::Commodity.find(name: "USD")
      params = update_params(usd)
      params[:version] = "bad version"
      put "/commodity/#{usd.commodity_id}", params
    }

    it "politely refuses to update" do
      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Compare Old/New Commodity"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this commodity"
    end
  end

  # FIXME: there is an error message after completing a delete?
  context "DELETE /commodity/:id" do
    let(:response) do
      usd = PiggyBank::Commodity.find(name: "USD")
      delete "/commodity/#{usd.commodity_id}", {
        _token: PiggyBank::App.token,
        version: usd.version,
      }
    end

    it "deletes the commodity" do
      usd = PiggyBank::Commodity.find(name: "USD")
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/commodities"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Commodity 'USD' deleted."
    end
  end

  context "DELETE /commodity/:id with invalid token" do
    let(:response) {
      usd = PiggyBank::Commodity.find(name: "USD")
      params = update_params(usd)
      params["_token"] = "bad penny"
      usd = PiggyBank::Commodity.where(name: "USD").single_record
      delete "/commodity/#{usd.commodity_id}", params
    }

    it "politely refuses to delete" do
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Delete Commodity?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
    end
  end

  context "DELETE /commodity/:id with version mismatch" do
    let(:response) {
      usd = PiggyBank::Commodity.find(name: "USD")
      params = update_params(usd)
      params[:version] = "bad version"
      delete "/commodity/#{usd.commodity_id}", params
    }

    it "politely refuses to delete" do
      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Delete Commodity?"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this commodity, please re-confirm delete"
    end
  end
end
