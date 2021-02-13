require_relative "../../spec_helper.rb"

describe PiggyBank::Tax::Data::W2 do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context ".new" do
    let(:w2) { PiggyBank::Tax::Data::W2.new }

    it "translates 'on' into boolean for #statutory_employee" do
      w2.statutory_employee = "on"
      expect(w2.statutory_employee).to eq true
      w2.statutory_employee = nil
      expect(w2.statutory_employee).to eq false
    end

    it "translate 'on' into boolean for #retirement_plan" do
      w2.retirement_plan = "on"
      expect(w2.retirement_plan).to eq true
      w2.retirement_plan = nil
      expect(w2.retirement_plan).to eq false
    end

    it "translate 'on' into boolean for #sick_pay" do
      w2.sick_pay = "on"
      expect(w2.sick_pay).to eq true
      w2.sick_pay = nil
      expect(w2.sick_pay).to eq false
    end
  end
end
