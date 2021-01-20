require "bigdecimal"

module PiggyBank
  class Amortization
    attr_accessor :principal, :rate, :number_of_payments, :payment_amount, :payments

    def initialize(principal, rate, number_of_payments)
      # FUTURE: round using Commodity#fraction
      @principal = BigDecimal(principal, 2)
      @rate = BigDecimal(rate, 6)
      @number_of_payments = number_of_payments
      @payment_amount = calculate_payment_amount
      @payments = calculate_payments
    end

    private

    def calculate_payment_amount
      pmt_rate = (1 + @rate) ** @number_of_payments
      pmt_numerator = @principal * @rate * pmt_rate
      pmt_denominator = pmt_rate - 1
      # FUTURE: round using Commodity#fraction
      pmt = (pmt_numerator / pmt_denominator).round(2)
    end

    def calculate_payments
      balance = @principal
      payments = []

      while balance > 0
        payment = {
          total_payment: @payment_amount,
          # FUTURE: round using Commodity#fraction
          interest: (balance * @rate).round(2),
        }
        payment[:principal] = @payment_amount - payment[:interest]
        balance = payment[:balance] = balance - payment[:principal]

        # FUTURE: round using Commodity#fraction
        next_interest = (balance * @rate).round(2)
        if next_interest + balance < @payment_amount
          payment[:principal] = payment[:principal] + balance
          payment[:total_payment] = payment[:principal] + payment[:interest]
          balance = payment[:balance] = 0
        end

        payments << payment
      end

      payments
    end
  end
end
