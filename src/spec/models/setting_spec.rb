require_relative "../spec_helper.rb"

describe PiggyBank::Setting do
  include Rack::Test::Methods

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
end
