require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  let(:app) { PiggyBank::App.new }

  context "GET /accounts" do
    let(:response) { get "/accounts" }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Accounts" }
  end

  context "GET /account" do
    let(:response) {
      liabilities = PiggyBank::Account.find(name: "Liabilities")
      get "/account?parent_id=#{liabilities.account_id}"
    }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "New Account" }
    it "has a form" do
      expect(response.body).to have_tag(
        "form",
        with: {
          method: "POST",
          action: "/account",
        },
      ) do
        with_tag "option", seen: "Liabilities", with: { selected: "selected" }
      end
    end
  end

  def create_params
    usd = PiggyBank::Commodity.find(name: "USD")
    equity = PiggyBank::Account.find(name: "Equity")
    {
      _token: PiggyBank::App.token,
      name: "Opening Balances",
      type: PiggyBank::Account::TYPE[:equity],
      parent_id: equity.account_id,
      commodity_id: usd.commodity_id,
      is_placeholder: false,
    }
  end

  context "POST /account" do
    let(:response) { post "/account", create_params }

    it "redirects to /accounts" do
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/accounts"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Account 'Opening Balances' created."
    end
  end

  context "POST /account with invalid token" do
    let(:response) {
      params = create_params
      params[:_token] = "bad token"
      post "/account", params
    }

    it "politely refuses to create" do
      expect(response.status).to eq 403
      expect(response.body).to have_tag "h1", text: "New Account"
      expect(response.body).to have_tag "div#flash"
      expect(response.body).to have_tag "div.flash.danger", text: "Failed to create, please try again"
    end
  end

  context "GET /account/:id" do
    let(:response) {
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      get "/account/#{mortgage.account_id}"
    }

    it { expect(response.status).to eq 200 }
    it { expect(response.body).to match /Account 'Liabilities:Mortgage'/ }
  end

  # context "GET /commodity/:id?edit" do
  #   let(:response) {
  #     cid = PiggyBank::Commodity.find(name: "USD").commodity_id
  #     get "/commodity/#{cid}?edit"
  #   }
  #   it { expect(response.status).to eq 200 }
  #   it { expect(response.body).to include "Edit Commodity" }

  #   it "has an edit form" do
  #     version = PiggyBank::Commodity.find(name: "USD").version
  #     expect(response.body).to have_tag("form", with: { method: "POST" }) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "option", seen: "1/100 (123.12)", with: { value: "100", selected: "selected" }
  #       with_tag "option", seen: "Currency", with: { value: "1", selected: "selected" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: version }
  #     end
  #   end
  # end

  # context "GET /commodity/:id?delete" do
  #   let(:response) {
  #     jpy = PiggyBank::Commodity.find(name: "JPY")
  #     get "/commodity/#{jpy.commodity_id}?delete"
  #   }

  #   it "has a delete confirmation form" do
  #     jpy = PiggyBank::Commodity.find(name: "JPY")
  #     expect(response.body).to include "Delete Commodity?"
  #     expect(response.status).to eq 200
  #     action = "/commodity/#{jpy.commodity_id}"
  #     expect(response.body).to have_tag("form", with: { method: "POST", action: action }) do
  #       with_tag "input", with: { name: "_token", type: "hidden" }
  #       with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
  #       with_tag "input", with: { name: "version", type: "hidden", value: jpy.version }
  #     end
  #   end
  # end

  # context "PUT /commodity/:id with valid params" do
  #   let(:response) do
  #     usd = PiggyBank::Commodity.where(name: "USD").single_record
  #     put "/commodity/#{usd.commodity_id}", update_params(usd)
  #   end

  #   it "updates the DB" do
  #     expect(response.status).to eq 200
  #     expect(response.body).to match /Commodity \d+/

  #     usb = PiggyBank::Commodity.where(name: "USB").single_record
  #     expect(usb.name).to eq "USB"
  #     expect(usb.description).to eq "Universal Serial Bus"
  #     expect(usb.ticker).to eq "USB"
  #     expect(usb.type).to eq 2
  #     expect(usb.fraction).to eq 1
  #   end
  # end

  # context "PUT /commodity/:id with invalid token" do
  #   let(:response) {
  #     usd = PiggyBank::Commodity.find(name: "USD")
  #     params = update_params(usd)
  #     params[:_token] = "bad token"
  #     put "/commodity/#{usd.commodity_id}", params
  #   }

  #   it "politely refuses to update" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Edit Commodity"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
  #   end
  # end

  # context "PUT /commodity/:id with version mismatch" do
  #   let(:response) {
  #     usd = PiggyBank::Commodity.find(name: "USD")
  #     params = update_params(usd)
  #     params[:version] = "bad version"
  #     put "/commodity/#{usd.commodity_id}", params
  #   }

  #   it "politely refuses to update" do
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Compare Old/New Commodity"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this commodity, please confirm changes"
  #   end
  # end

  # context "DELETE /commodity/:id" do
  #   it "deletes the commodity" do
  #     jpy = PiggyBank::Commodity.find(name: "JPY")
  #     response = delete "/commodity/#{jpy.commodity_id}", {
  #       _token: PiggyBank::App.token,
  #       version: jpy.version,
  #     }
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/commodities"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "Commodity 'JPY' deleted."
  #   end
  # end

  # context "DELETE /commodity/:id with invalid token" do
  #   let(:response) {
  #     jpy = PiggyBank::Commodity.find(name: "JPY")
  #     params = update_params(jpy)
  #     params["_token"] = "bad penny"
  #     usd = PiggyBank::Commodity.find(name: "JPY")
  #     delete "/commodity/#{jpy.commodity_id}", params
  #   }

  #   it "politely refuses to delete" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Delete Commodity?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
  #   end
  # end

  # context "DELETE /commodity/:id with version mismatch" do
  #   let(:response) {
  #     usd = PiggyBank::Commodity.find(name: "USD")
  #     params = update_params(usd)
  #     params[:version] = "bad version"
  #     delete "/commodity/#{usd.commodity_id}", params
  #   }

  #   it "politely refuses to delete" do
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Delete Commodity?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this commodity, please re-confirm delete"
  #   end
  # end
end

# ZZZ: pass list of accounts

# ZZZ: GET /account = new account form
# ZZZ: POST /account = create account
# ZZZ: CSRF protection for /account

# TODO: GET /account/:id = view account
# TODO: GET /account/:id?edit = edit account form
# TODO: PUT /account/:id = update account

# TODO: GET /account/:id?delete = confirm delete form
# TODO: DELETE /account/:id = delete account

# FUTURE: GET /accounts/import = import textual chart of accounts
# FUTURE: GET /accounts/setup = preset account lists to choose from
