require_relative "../../../../../spec_helper.rb"

describe PiggyBank::Tax::Form::Adapter::US::Form1040 do
  context "new instance" do
    let(:form) { PiggyBank::Tax::Form::Adapter::US::Form1040.new }
    it "calculates line 1, total wages" do
      expect(form.line_1).to eq BigDecimal("36323")
    end
  end
end
