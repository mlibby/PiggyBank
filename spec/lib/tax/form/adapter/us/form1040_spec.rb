require_relative "../../../../../spec_helper.rb"

describe PiggyBank::Tax::Form::Adapter::US::Form1040 do
  context "new instance" do
    let(:form) { PiggyBank::Tax::Form::Adapter::US::Form1040.new }
    it "calculates line 1, total wages" do
      expect(form.line_1).to eq 93921
    end

    it "calculates tax amounts" do 
      expect(form.get_tax_amount(_d("78901.0"), :joint)).to eq 9076
      expect(form.get_tax_amount(_d("61049.0"), :single)).to eq 9216
      expect(form.get_tax_amount(_d("123456.0"), :single)).to eq 23709
      expect(form.get_tax_amount(_d("666666.0"), :hoh)).to eq 209652
      expect(form.get_tax_amount(_d("666666.0"), :separate)).to eq 215241
    end
  end
end
