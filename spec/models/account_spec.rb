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

    # it "is invalid at first" do
    #   expect(instance.valid?).to be false
    # end

    # it "is valid after attributes set" do
    #   instance.name = "USD"
    #   instance.description = "US Dollar"
    #   instance.fraction = 100
    #   instance.type = 1
    #   expect(instance.valid?).to be true
    # end

    it "has a version after save" do
      instance.name = "Checking"
      instance.parent_id = assets.account_id
      instance.commodity_id = usd.commodity_id
      instance.is_placeholder = false
      instance.type = PiggyBank::Account::TYPE[:asset]
      instance.save

      expect(instance.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end

    # it "has a type_string attribute" do
    #   instance.type = 1
    #   expect(instance.type_string).to eq("Currency")
    # end

    # it "has a fraction_opts method" do
    #   fraction_opts = instance.fraction_opts
    #   expect(fraction_opts.length).to eq 7
    #   expect(fraction_opts[0][:value]).to eq 1
    #   expect(fraction_opts[6][:value]).to eq 1000000
    # end

    # it "has a type_opts method" do
    #   type_opts = instance.type_opts
    #   expect(type_opts.length).to eq 2
    # end
  end

  context "existing instance" do
    # before(:example) do
    #   PiggyBank::Commodity.truncate
    #   PiggyBank::Commodity.create name: "USD",
    #                               description: "US Dollar",
    #                               type: 1,
    #                               fraction: 100
    # end

    # it "can be loaded from DB" do
    #   instance = PiggyBank::Commodity.find(name: "USD")
    #   expect(instance.description).to eq "US Dollar"
    # end

    # it "can be changed and saved" do
    #   instance = PiggyBank::Commodity.find(name: "USD")
    #   instance.name = "CAD"
    #   expect { instance.save }.not_to raise_error
    # end

    # it "cannot be saved if version # doesn't match" do
    #   instance = PiggyBank::Commodity.find(name: "USD")
    #   instance.name = "CAD"
    #   instance.version = "2021-01-06T12:34:56+00:00"
    #   expect { instance.save }.to raise_error(Sequel::ValidationFailed)
    # end

    it "Account#parent" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      expect(mortgage.parent.name).to eq "Liabilities"
    end

    it "Account#long_name" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")
      expect(mortgage.long_name).to eq "Liabilities:Mortgage"
    end

    it "Account#account_opts has correct option selected" do
      mortgage = PiggyBank::Account.find(name: "Mortgage")

      account_opts = mortgage.account_opts
      expect(account_opts.length).to eq 6

      mortgage_opt = account_opts.find { |ao| ao[:value] == mortgage.account_id }
      expect(mortgage_opt[:selected]).to eq true
    end

    # it "type_opts has correct option selected" do
    #   instance = PiggyBank::Commodity.find(name: "USD")
    #   type_opts = instance.type_opts
    #   expect(type_opts[0][:value]).to eq 1
    #   expect(type_opts[0][:selected]).to eq true
    # end
  end
end
