from functools import reduce


class Amortization:
    def __init__(self, principal, rate, number):
        self.principal = principal
        self.rate = rate
        self.number = number

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
            payment = {
                'number': payment_number,
                'total': self.payment_amount,
                'interest': round(balance * self._rate, 2),
            }
            payment['principal'] = self.payment_amount - payment['interest']
            balance = payment['balance'] = balance - payment['principal']

            #next_interest = round(balance * self._rate, 2)
            if payment_number == self.number:
                payment['principal'] = payment['principal'] + balance
                payment['total'] = \
                    payment['principal'] + payment['interest']
                balance = payment['balance'] = 0
            payments.append(payment)
        return payments

    def total_interest(self):
        return reduce(lambda acc, i: acc + i['interest'], self.payments, 0)
