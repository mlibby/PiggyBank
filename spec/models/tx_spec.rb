require_relative "../spec_helper.rb"

describe PiggyBank::Tx do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context "new instance" do
    it "is invalid at first" do
      tx = PiggyBank::Tx.new
      expect(tx.valid?).to be false
    end

    def set_attributes(tx)
      tx.post_date = "2021-01-27"
      tx.description = "tx description"
      tx.splits << PiggyBank::Split.new
      tx.splits << PiggyBank::Split.new
    end

    it "is valid after attributes set" do
      tx = PiggyBank::Tx.new
      set_attributes tx
      expect(tx.valid?).to be true
    end

    it "has a version after save" do
      tx = PiggyBank::Tx.new
      set_attributes tx
      tx.save
      expect(tx.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end
  end
end

# ZZZ: tx validation required
# ZZZ: validate required attributes
# ZZZ: version on save
