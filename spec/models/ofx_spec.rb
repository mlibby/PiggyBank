require_relative "../spec_helper.rb"

describe PiggyBank::Ofx do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context "new instance" do
    # it "is invalid at first" do
    #   ofx = PiggyBank::Ofx.new
    #   expect(ofx.valid?).to be false
    # end

    def set_attributes(ofx)
      # ofx.description = "ofx description"
      # ofx.value = "api key value"
    end

    it "is valid after attributes set" do
      ofx = PiggyBank::Ofx.new
      set_attributes ofx
      expect(ofx.valid?).to be true
    end

    # it "has a version after save" do
    #   ofx = PiggyBank::Ofx.new
    #   set_attributes ofx
    #   ofx.save
    #   expect(ofx.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    # end
  end
end

# TODO: ofx validation required
# TODO: validate required attributes
# TODO: version on save
