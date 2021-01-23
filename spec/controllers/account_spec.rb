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
end
