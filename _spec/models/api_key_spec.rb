require_relative "../spec_helper.rb"

describe PiggyBank::ApiKey do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context "new instance" do
    it "is invalid at first" do
      api_key = PiggyBank::ApiKey.new
      expect(api_key.valid?).to be false
    end

    def set_attributes(api_key)
      api_key.description = "api_key description"
      api_key.value = "api key value"
    end

    it "is valid after attributes set" do
      api_key = PiggyBank::ApiKey.new
      set_attributes api_key
      expect(api_key.valid?).to be true
    end

    it "has a version after save" do
      api_key = PiggyBank::ApiKey.new
      set_attributes api_key
      api_key.save
      expect(api_key.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end
  end
end

# ZZZ: api_key validation required
# ZZZ: validate required attributes
# ZZZ: version on save
