require_relative "../spec_helper.rb"

describe PiggyBank::Setting do
  include Rack::Test::Methods

  before :all do
    setting = PiggyBank::Setting.new
    setting.name = "currency"
    setting.value = "USD"
    setting.save
  end

  context "new instance" do
    let(:setting) { PiggyBank::Setting.new }

    it "is invalid at first" do
      expect(setting.valid?).to be false
    end

    it "is valid after attributes set" do
      setting.name = "name"
      setting.value = "value"
      expect(setting.valid?).to be true
    end

    it "fails to set invalid attribute" do
      expect { setting.foo = "foo" }.to raise_error(NoMethodError)
    end

    it "has a version after save" do
      setting.name = "name"
      setting.value = "value"
      setting.save
      expect(setting.version).to match(/\d{4}\-\d\d-\d\dT\d\d:\d\d:\d\d\+00:00/)
    end
  end

  context "existing instance" do
    it "can be loaded from DB" do
      setting = PiggyBank::Setting.find(name: "currency")
      expect(setting.value).to eq "USD"
    end

    it "can be changed and saved" do
      setting = PiggyBank::Setting.find(name: "currency")
      setting.value = "CAD"
      expect { setting.save }.not_to raise_error
    end

    it "cannot be saved if version # doesn't match" do
      setting = PiggyBank::Setting.find(name: "currency")
      setting.value = "CAD"
      setting.version = "2021-01-06T12:34:56+00:00"
      expect { setting.save }.to raise_error(Sequel::ValidationFailed)
    end
  end
end
