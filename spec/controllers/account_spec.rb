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

  context "POST /account" do
    let(:response) {
      usd = PiggyBank::Commodity.find(name: "USD")
      equity = PiggyBank::Account.find(name: "Equity")
      params = {
        _token: PiggyBank::App.token,
        name: "Opening Balances",
        type: PiggyBank::Account::TYPE[:equity],
        parent_id: equity.account_id,
        commodity_id: usd.commodity_id,
        is_placeholder: false,
      }
      post "/account", params
    }

    it "redirects to /accounts" do
      expect(response.status).to eq 302
      location = URI(response.headers["Location"])
      expect(location.path).to eq "/accounts"
      expect(flash).to have_key :success
      expect(flash[:success]).to eq "Account 'Opening Balances' created."
    end
  end
end
