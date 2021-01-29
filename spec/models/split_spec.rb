require_relative "../spec_helper.rb"

describe PiggyBank::Split do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  #context "new instance" do
  #let(:instance) { PiggyBank::Split.new }

  # it "is invalid at first" do
  #   expect(true).to be true
  #   expect(instance.valid?).to be false
  # end

  # it "is valid after attributes set" do
  #   instance.name = "Checking"
  #   instance.type = PiggyBank::Split::TYPE[:asset]
  #   instance.parent = PiggyBank::Split.find(name: "Assets")
  #   instance.commodity = PiggyBank::Commodity.find(name: "USD")
  #   instance.is_placeholder = false
  #   expect(instance.valid?).to be true
  # end

  # it "has a version after save" do
  #   instance.name = "Checking"
  #   instance.parent_id = assets.split_id
  #   instance.commodity_id = usd.commodity_id
  #   instance.is_placeholder = false
  #   instance.type = PiggyBank::Split::TYPE[:asset]
  #   instance.save

  #   expect(instance.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
  # end
  # end

  # context "existing instance" do
  #   it "Split#parent" do
  #     mortgage = PiggyBank::Split.find(name: "Mortgage")
  #     expect(mortgage.parent.name).to eq "Liabilities"
  #   end

  #   it "Split#long_name" do
  #     mortgage = PiggyBank::Split.find(name: "Mortgage")
  #     expect(mortgage.long_name).to eq "Liabilities:Mortgage"
  #   end

  #   it "Split#split_opts has correct option selected" do
  #     mortgage = PiggyBank::Split.find(name: "Mortgage")

  #     split_opts = mortgage.split_opts
  #     expect(split_opts.length).to eq 6

  #     mortgage_opt = split_opts.find { |ao| ao[:value] == mortgage.split_id }
  #     expect(mortgage_opt[:selected]).to eq true
  #   end
  #end
end

# TODO: split validation required
# TODO: validate required attributes
# TODO: version on save
