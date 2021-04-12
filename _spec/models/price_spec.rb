require_relative "../spec_helper.rb"

describe PiggyBank::Price do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context "#new" do
    let(:price) { PiggyBank::Price.new }
    let(:usd) { PiggyBank::Commodity.find(name: "USD") }
    let(:jpy) { PiggyBank::Commodity.find(name: "JPY") }
    
    it "is invalid at first" do
      expect(price.valid?).to be false
    end

    it "is valid after attributes set" do
      price.quote_date = "2021-01-29"
      price.commodity_id = usd.commodity_id
      price.currency_id = jpy.commodity_id
      price.value = 1.23
      expect(price.valid?).to be true
    end

    it "has a version after save" do
      price.quote_date = "2021-01-29"
      price.commodity_id = usd.commodity_id
      price.currency_id = jpy.commodity_id
      price.value = 1.23
      price.save

      expect(price.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end
  end
end

# ZZZ: price validation required
# ZZZ: validate required attributes
# ZZZ: version on save
