require_relative "../spec_helper.rb"

describe PiggyBank::App do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end  

  let(:app) { PiggyBank::App.new }

  context "get /accounts" do
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
end
