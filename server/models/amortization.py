from collections import namedtuple
from decimal import Decimal
from functools import reduce


class Amortization:
    Payment = namedtuple('Payment', 'number principal interest prepay balance')
    
    def __init__(self, principal, rate, number):
        self.principal = Decimal(principal)
        self.rate = Decimal(rate)
        self.number = int(number)

        # inner rate is rate divided by months divided by 100
        self._rate = self.rate / 1200
        self.payment_amount = self.calculate_payment_amount()
        self.payments = self.calculate_payments()

    def calculate_payment_amount(self):
        pmt_rate = (1 + self._rate) ** self.number
        pmt_numerator = self.principal * self._rate * pmt_rate
        pmt_denominator = pmt_rate - 1
        # FUTURE: round using Commodity#fraction
        return round(pmt_numerator / pmt_denominator, 2)

    def calculate_payments(self):
        balance = self.principal
        payments = []
        payment_number = 0
        while balance > 0:
            payment_number += 1
            interest = round(balance * self._rate, 2)
            principal = self.payment_amount - interest
            balance = balance - principal

            if payment_number == self.number:
                principal = principal + balance
                balance = 0

            payment = Amortization.Payment(
                number = payment_number,
                principal = principal,
                interest = interest,
                prepay = Decimal("0.0"),
                balance = balance
            )

            payments.append(payment)
        return payments

    def total_interest(self):
        return reduce(lambda acc, p: acc + p.interest, self.payments, 0)
