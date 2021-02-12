require_relative "../../spec_helper.rb"

describe PiggyBank::Tax::Income do
  include Rack::Test::Methods

  before(:example) do
    seed_db
  end

  context ".new" do
    let(:income) { PiggyBank::Tax::Income.new }

    it "has W2s" do
      expect(income.w2s.size).to eq 2
    end

    it "calculates total wages" do
      expect(income.total_wages).to eq 36323
    end
  end
end
