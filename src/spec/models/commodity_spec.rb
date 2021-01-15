require_relative "../spec_helper.rb"

describe PiggyBank::Commodity do
  include Rack::Test::Methods

  context "new instance" do
    before(:example) do
      PiggyBank::Commodity.truncate
    end
    
    let(:instance) { PiggyBank::Commodity.new }

    it "is invalid at first" do
      expect(instance.valid?).to be false
    end

    it "is valid after attributes set" do
      instance.name = "USD"
      instance.description = "US Dollar"
      instance.fraction = 100
      instance.type = 1
      expect(instance.valid?).to be true
    end

    it "has a version after save" do
      instance.name = "USD"
      instance.description = "US Dollar"
      instance.fraction = 100
      instance.type = 1
      instance.save
      expect(instance.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end
  end

  context "existing instance" do
    before(:example) do
      PiggyBank::Commodity.truncate
      PiggyBank::Commodity.create name: "USD",
                                  description: "US Dollar",
                                  type: 1,
                                  fraction: 100
    end

    it "can be loaded from DB" do
      instance = PiggyBank::Commodity.find(name: "USD")
      expect(instance.description).to eq "US Dollar"
    end

    it "can be changed and saved" do
      instance = PiggyBank::Commodity.find(name: "USD")
      instance.name = "CAD"
      expect { instance.save }.not_to raise_error
    end

    it "cannot be saved if version # doesn't match" do
      instance = PiggyBank::Commodity.find(name: "USD")
      instance.name = "CAD"
      instance.version = "2021-01-06T12:34:56+00:00"
      expect { instance.save }.to raise_error(Sequel::ValidationFailed)
    end
  end
end
