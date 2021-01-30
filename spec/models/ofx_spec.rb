require_relative "../spec_helper.rb"

describe PiggyBank::Ofx do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context "new instance" do
    it "is invalid at first" do
      ofx = PiggyBank::Ofx.new
      expect(ofx.valid?).to be false
    end

    def set_attributes(ofx)
      ofx.active = true
      ofx.account_id = PiggyBank::Account.find(name: "Assets").account_id
      ofx.url = "foo.bar.com" 
      ofx.user = "ofx user"
      ofx.password = "ofx pass" 
      ofx.fid = "12345"
      ofx.fid_org = "B1" 
      ofx.bank_id = "x"
      ofx.bank_account_id = "*****"
      ofx.account_type = "CHECKING"
    end

    it "is valid after attributes set" do
      ofx = PiggyBank::Ofx.new
      set_attributes ofx
      expect(ofx.valid?).to be true
    end

    it "has a version after save" do
      ofx = PiggyBank::Ofx.new
      set_attributes ofx
      ofx.save
      expect(ofx.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end
  end
end

# ZZZ: ofx validation required
# ZZZ: validate required attributes
# ZZZ: version on save
