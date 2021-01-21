require_relative "../spec_helper.rb"

describe PiggyBank::Commodity do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context "new instance" do
    let(:instance) { PiggyBank::Commodity.new }

    it "is invalid at first" do
      expect(instance.valid?).to be false
    end

    it "is valid after attributes set" do
      instance.name = "JPY"
      instance.description = "Japanese Yen"
      instance.fraction = 1
      instance.type = 1
      expect(instance.valid?).to be true
    end

    it "has a version after save" do
      instance.name = "JPY"
      instance.description = "Japanese Yen"
      instance.fraction = 1
      instance.type = 1
      instance.save
      expect(instance.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end

    it "has a type_string attribute" do
      instance.type = 1
      expect(instance.type_string).to eq("Currency")
    end

    it "has a fraction_opts method" do
      fraction_opts = instance.fraction_opts
      expect(fraction_opts.length).to eq 7
      expect(fraction_opts[0][:value]).to eq 1
      expect(fraction_opts[6][:value]).to eq 1000000
    end

    it "has a type_opts method" do
      type_opts = instance.type_opts
      expect(type_opts.length).to eq 2
    end
  end

  context "existing instance" do
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

    it "fraction_opts has correct option selected" do
      instance = PiggyBank::Commodity.find(name: "USD")
      fraction_opts = instance.fraction_opts
      expect(fraction_opts[2][:value]).to eq 100
      expect(fraction_opts[2][:selected]).to eq true
    end

    it "type_opts has correct option selected" do
      instance = PiggyBank::Commodity.find(name: "USD")
      type_opts = instance.type_opts
      expect(type_opts[0][:value]).to eq 1
      expect(type_opts[0][:selected]).to eq true
    end
  end
end
