require_relative "../../spec_helper.rb"

describe PiggyBank::Tax::Data::Income do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context ".new" do
    let(:income) { PiggyBank::Tax::Data::Income.new }

    it "has W2s" do
      expect(income.w2s.size).to eq 2
    end
    
    it "#add_w2 adds blank w2" do
      count = income.w2s.size
      income.add_w2
      expect(income.w2s.size).to eq count + 1
    end
  end
end
