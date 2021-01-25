require "date"
require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:context) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "get /prices" do
    let(:response) { get "/prices" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Prices" }
  end

  context "GET /price" do
    let(:response) {
      get "/price"
    }

    it {
      expect(response.status).to eq 200
    }
    it { expect(response.body).to include "New Price" }
    it "has a form" do
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/price",
        },
      ) do
        with_tag "select", name: "currency_id"
        with_tag "select", name: "commodity_id"
      end
    end
  end

  def create_params
    usd = PiggyBank::Commodity.find(name: "USD")
    cad = PiggyBank::Commodity.find(name: "CAD")
    {
      _token: PiggyBank::App.token,
      quote_date: Date.today.to_s,
      commodity_id: cad.commodity_id,
      currency_id: usd.commodity_id,
      value: BigDecimal("123.45"),
    }
  end

  context "POST /price" do
    it "redirects to /prices after saving price" do
      response = post "/price", create_params

      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/prices"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Price created."
    end
  end

  context "POST /price with invalid token" do
    it "politely refuses to create" do
      params = create_params
      params[:_token] = "bad token"
      response = post "/price", params
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "New Price"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
    end
  end

  context "GET /price/:id" do
    it "view a price" do
      price = PiggyBank::Price.first
      response = get "/price/#{price.price_id}"
      expect(response.status).to eq 200
      expect(response.body).to match "Price '#{price.price_id}'"
    end
  end

  context "GET /price/:id?edit" do
    it "has an edit form" do
      price = PiggyBank::Price.first
      response = get "/price/#{price.price_id}?edit"
      expect(response.status).to eq 200
      expect(response.body).to include "Edit Price"

      version = price.version
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
        with_tag "input", with: { name: "version", type: "hidden", value: version }
      end
    end
  end

  context "GET /price/:id?delete" do
    it "has a delete confirmation form" do
      price = PiggyBank::Price.first
      response = get "/price/#{price.price_id}?delete"
      expect(response.body).to include "Delete Price?"
      expect(response.status).to eq 200
      action = "/price/#{price.price_id}"
      expect(response.body).to have_tag("form", with: { method: "POST", action: action }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
        with_tag "input", with: { name: "version", type: "hidden", value: price.version }
      end
    end
  end

  def update_params(existing)
    {
      _token: PiggyBank::App.token,
      quote_date: "2021-01-23",
      commodity_id: PiggyBank::Commodity.find(name: "CAD").commodity_id,
      currency_id: PiggyBank::Commodity.find(name: "JPY").commodity_id,
      value: BigDecimal("432"),
      version: existing.version,
    }
  end

  context "PUT /price/:id with valid params" do
    it "updates the DB" do
      price = PiggyBank::Price.first
      response = put "/price/#{price.price_id}", update_params(price)

      expect(response.status).to eq 200

      price = PiggyBank::Price.find(price_id: price.price_id)
      cad = PiggyBank::Commodity.find(name: "CAD")
      jpy = PiggyBank::Commodity.find(name: "JPY")

      expect(price.quote_date).to eq "2021-01-23"
      expect(price.commodity_id).to eq cad.commodity_id
      expect(price.currency_id).to eq jpy.commodity_id
      expect(price.value).to eq BigDecimal("432")
    end
  end

  context "PUT /price/:id with invalid token" do
    it "politely refuses to update" do
      price = PiggyBank::Price.first
      params = update_params(price)
      params[:_token] = "bad token"
      response = put "/price/#{price.price_id}", params

      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "Edit Price"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
    end
  end

  context "PUT /price/:id with version mismatch" do
    it "politely refuses to update" do
      price = PiggyBank::Price.first
      params = update_params(price)
      params[:version] = "bad version"
      response = put "/price/#{price.price_id}", params
      expect(response.status).to eq 409
      expect(response.body).to have_tag "h1", text: "Compare Old/New Price"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this price, please confirm changes"
    end
  end

  # context "DELETE /price/:id" do
  #   it "deletes the price" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     response = delete "/price/#{mortgage.price_id}", {
  #       _token: PiggyBank::App.token,
  #       version: mortgage.version,
  #     }
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/prices"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "price 'Mortgage' deleted."
  #   end
  # end

  # context "DELETE /price/:id with invalid token" do
  #   it "politely refuses to delete" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params["_token"] = "bad penny"
  #     response = delete "/price/#{mortgage.price_id}", params
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Delete price?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
  #   end
  # end

  # context "DELETE /price/:id with version mismatch" do
  #   it "politely refuses to delete" do
  #     mortgage = PiggyBank::price.find(name: "Mortgage")
  #     params = update_params(mortgage)
  #     params[:version] = "bad version"
  #     response = delete "/price/#{mortgage.price_id}", params

  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Delete price?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this price, please re-confirm delete"
  #   end
  # end
end

# ZZZ: GET /price = new price form
# ZZZ: POST /price = create price
# ZZZ: POST /price CSRF protection

# ZZZ: GET /price/:id = view price
# ZZZ: GET /price/:id?edit = edit price form
# ZZZ: PUT /price/:id = update price
# ZZZ: PUT /price/:id CSRF prevention
# ZZZ: PUT /price/:id version mismatch

# TODO: GET /price/:id?delete = confirm delete form
# TODO: DELETE /price/:id = delete price
# TODO: DELETE /price/:id CSRF prevention
# TODO: DELETE /price/:id version mismatch
