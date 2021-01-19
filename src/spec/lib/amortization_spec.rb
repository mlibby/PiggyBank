require_relative "../spec_helper.rb"

describe PiggyBank::Amortization do
  context "new instance" do
    let(:amort) {
      PiggyBank::Amortization.new 100_000, 0.06 / 12, 360
    }

    it "calculates payment amount" do
      expect(amort.payment_amount).to eq 599.55
    end

    it "calculates payment schedule" do
      expect(amort.payments.length).to eq 360
    end

    it "calculate last payment as a 'balloon' with extra principal" do
      # FIXME: need to convert amortization to use BigDecimal
      #expect(amort.payments[359][:total_payment]).to eq 600.00
    end
  end
end
