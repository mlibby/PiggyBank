require_relative "../spec_helper.rb"

describe PiggyBank::Split do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context "new split" do
    let(:split) { PiggyBank::Split.new }
    let(:assets) { PiggyBank::Account.find(name: "Assets") }
    let(:tx) { PiggyBank::Tx.first }

    it "is invalid at first" do
      expect(split.valid?).to be false
    end

    it "is valid after attributes set" do
      split.tx_id = tx.tx_id
      split.memo = "split memo"
      split.account_id = assets.account_id
      split.amount = 12.23
      split.value = 12.23
      expect(split.valid?).to be true
    end

    it "has a version after save" do
      split.tx_id = tx.tx_id
      split.memo = "split memo"
      split.account_id = assets.account_id
      split.amount = 12.23
      split.value = 12.23
      split.save

      expect(split.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end
  end

end

# ZZZ: split validation required
# ZZZ: validate required attributes
# ZZZ: version on save
