require_relative "../spec_helper.rb"

describe PiggyBank::Tx do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  #context "new instance" do
    #let(:instance) { PiggyBank::Tx.new }

    # TODO: tx validation required
    # it "is invalid at first" do
    #   expect(true).to be true
    #   expect(instance.valid?).to be false
    # end

    # TODO: validate required attributes
    # it "is valid after attributes set" do
    #   instance.name = "Checking"
    #   instance.type = PiggyBank::Tx::TYPE[:asset]
    #   instance.parent = PiggyBank::Tx.find(name: "Assets")
    #   instance.commodity = PiggyBank::Commodity.find(name: "USD")
    #   instance.is_placeholder = false
    #   expect(instance.valid?).to be true
    # end

    # TODO: version on save
    # it "has a version after save" do
    #   instance.name = "Checking"
    #   instance.parent_id = assets.tx_id
    #   instance.commodity_id = usd.commodity_id
    #   instance.is_placeholder = false
    #   instance.type = PiggyBank::Tx::TYPE[:asset]
    #   instance.save

    #   expect(instance.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    # end
  # end

  # context "existing instance" do
  #   it "Tx#parent" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     expect(mortgage.parent.name).to eq "Liabilities"
  #   end

  #   it "Tx#long_name" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")
  #     expect(mortgage.long_name).to eq "Liabilities:Mortgage"
  #   end

  #   it "Tx#tx_opts has correct option selected" do
  #     mortgage = PiggyBank::Tx.find(name: "Mortgage")

  #     tx_opts = mortgage.tx_opts
  #     expect(tx_opts.length).to eq 6

  #     mortgage_opt = tx_opts.find { |ao| ao[:value] == mortgage.tx_id }
  #     expect(mortgage_opt[:selected]).to eq true
  #   end
  #end
end
