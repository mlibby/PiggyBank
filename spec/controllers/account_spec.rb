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

  context "GET /account/:id?edit" do
    let(:response) {
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      get "/account/#{mortgage.account_id}?edit"
    }
    it { expect(response.status).to eq 200 }
    it { expect(response.body).to include "Edit Account" }

    it "has an edit form" do
      version = PiggyBank::Account.find(name: "Mortgage").version
      expect(response.body).to have_tag("form", with: { method: "POST" }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "PUT" }
        with_tag "input", with: { name: "version", type: "hidden", value: version }
      end
    end
  end

  context "GET /account/:id?delete" do
    it "has a delete confirmation form" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      response = get "/account/#{mortgage.account_id}?delete"
      expect(response.body).to include "Delete Account?"
      expect(response.status).to eq 200
      action = "/account/#{mortgage.account_id}"
      expect(response.body).to have_tag("form", with: { method: "POST", action: action }) do
        with_tag "input", with: { name: "_token", type: "hidden" }
        with_tag "input", with: { name: "_method", type: "hidden", value: "DELETE" }
        with_tag "input", with: { name: "version", type: "hidden", value: mortgage.version }
      end
    end
  end

  def update_params(existing)
    {
      _token: PiggyBank::App.token,
      name: "Home Mortgage",
      type: 2,
      parent_id: PiggyBank::Account.find(name: "Assets").account_id,
      commodity_id: PiggyBank::Commodity.find(name: "CAD").commodity_id,
      is_placeholder: true,
      version: existing.version,
    }
  end

  context "PUT /account/:id with valid params" do
    it "updates the DB" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      response = put "/account/#{mortgage.account_id}", update_params(mortgage)
          
      expect(response.status).to eq 200

      mortgage = PiggyBank::Account.find(name: "Home Mortgage")
      assets = PiggyBank::Account.find(name: "Assets")
      cad = PiggyBank::Commodity.find(name: "CAD")

      expect(mortgage.type).to eq 2
      expect(mortgage.parent_id).to eq assets.account_id
      expect(mortgage.commodity_id).to eq cad.commodity_id
      expect(mortgage.is_placeholder).to be true
    end
  end

  # context "PUT /account/:id with invalid token" do
  #   let(:response) {
  #     usd = PiggyBank::account.find(name: "USD")
  #     params = update_params(usd)
  #     params[:_token] = "bad token"
  #     put "/account/#{usd.account_id}", params
  #   }

  #   it "politely refuses to update" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Edit account"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to save changes, please try again"
  #   end
  # end

  # context "PUT /account/:id with version mismatch" do
  #   let(:response) {
  #     usd = PiggyBank::account.find(name: "USD")
  #     params = update_params(usd)
  #     params[:version] = "bad version"
  #     put "/account/#{usd.account_id}", params
  #   }

  #   it "politely refuses to update" do
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Compare Old/New account"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this account, please confirm changes"
  #   end
  # end

  # context "DELETE /account/:id" do
  #   it "deletes the account" do
  #     jpy = PiggyBank::account.find(name: "JPY")
  #     response = delete "/account/#{jpy.account_id}", {
  #       _token: PiggyBank::App.token,
  #       version: jpy.version,
  #     }
  #     expect(response.status).to eq 302
  #     location = URI(response.headers["Location"])
  #     expect(location.path).to eq "/commodities"
  #     expect(flash).to have_key :success
  #     expect(flash[:success]).to eq "account 'JPY' deleted."
  #   end
  # end

  # context "DELETE /account/:id with invalid token" do
  #   let(:response) {
  #     jpy = PiggyBank::account.find(name: "JPY")
  #     params = update_params(jpy)
  #     params["_token"] = "bad penny"
  #     usd = PiggyBank::account.find(name: "JPY")
  #     delete "/account/#{jpy.account_id}", params
  #   }

  #   it "politely refuses to delete" do
  #     expect(response.status).to eq 403
  #     expect(response.body).to have_tag "h1", text: "Delete account?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Failed to delete, please try again"
  #   end
  # end

  # context "DELETE /account/:id with version mismatch" do
  #   let(:response) {
  #     usd = PiggyBank::account.find(name: "USD")
  #     params = update_params(usd)
  #     params[:version] = "bad version"
  #     delete "/account/#{usd.account_id}", params
  #   }

  #   it "politely refuses to delete" do
  #     expect(response.status).to eq 409
  #     expect(response.body).to have_tag "h1", text: "Delete account?"
  #     expect(response.body).to have_tag "div#flash"
  #     expect(response.body).to have_tag "div.flash.danger", text: "Someone else updated this account, please re-confirm delete"
  #   end
  # end
end

# ZZZ: pass list of accounts

# ZZZ: GET /account = new account form
# ZZZ: POST /account = create account
# ZZZ: CSRF protection for /account

# ZZZ: GET /account/:id = view account
# ZZZ: GET /account/:id?edit = edit account form
# ZZZ: PUT /account/:id = update account
# TODO: PUT /account/:id CSRF prevention
# TODO: PUT /account/:id version mismatch

# ZZZ: GET /account/:id?delete = confirm delete form
# TODO: prevent deletion of top-level accounts
# TODO: DELETE /account/:id = delete account
# TODO: DELETE /account/:id CSRF prevention
# TODO: DELETE /account/:id version mismatch

# FUTURE: GET /accounts/import = import textual chart of accounts
# FUTURE: GET /accounts/setup = preset account lists to choose from
