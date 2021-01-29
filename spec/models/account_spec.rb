require_relative "../spec_helper.rb"

describe PiggyBank::Account do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  let(:assets) { PiggyBank::Account.find(name: "Assets") }
  let(:usd) { PiggyBank::Commodity.find(name: "USD") }

  context "class" do
    it "Account.as_chart returns all accounts as tree" do
      accounts = PiggyBank::Account.as_chart
      account_names = accounts.map { |a| a.name }
      expect(accounts.length).to eq 5
      %w{Assets Liabilities Equity Income Expense}.each do |primary|
        expect(account_names).to include primary
      end

      equity = accounts.find { |a| a.name == "Equity" }
      liabilities = accounts.find { |a| a.name == "Liabilities" }
      expect(liabilities.subaccounts).not_to be_empty
      expect(equity.subaccounts).to be_empty
      expect(liabilities.has_subaccounts?).to be true
      expect(equity.has_subaccounts?).to be false
    end
  end

  context "new instance" do
    let(:instance) { PiggyBank::Account.new }

    it "is invalid at first" do
      expect(true).to be true
      expect(instance.valid?).to be false
    end

    it "is valid after attributes set" do
      instance.name = "Checking"
      instance.type = PiggyBank::Account::TYPE[:asset]
      instance.parent = PiggyBank::Account.find(name: "Assets")
      instance.commodity = PiggyBank::Commodity.find(name: "USD")
      instance.is_placeholder = false
      expect(instance.valid?).to be true
    end

    it "has a version after save" do
      instance.name = "Checking"
      instance.parent_id = assets.account_id
      instance.commodity_id = usd.commodity_id
      instance.is_placeholder = false
      instance.type = PiggyBank::Account::TYPE[:asset]
      instance.save

      expect(instance.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end

    it "has a type_string attribute" do
      instance.type = PiggyBank::Account::TYPE[:equity]
      expect(instance.type_string).to eq("Equity")
    end
  end

  context "existing instance" do
    it "Account#parent" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      expect(mortgage.parent.name).to eq "Liabilities"
    end

    it "Account#long_name" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      expect(mortgage.long_name).to eq "Liabilities:Mortgage"
    end

    it "Account.account_opts has correct option selected" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")

      account_opts = PiggyBank::Account.account_opts mortgage
      expect(account_opts.length).to eq 7

      mortgage_opt = account_opts.find { |ao| ao[:value] == mortgage.account_id }
      expect(mortgage_opt[:selected]).to eq true
    end
  end
end
