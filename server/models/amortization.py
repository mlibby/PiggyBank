from collections import namedtuple
from decimal import Decimal
from functools import reduce


class Amortization:
    Payment = namedtuple(
        "Payment",
        "number total principal interest extra_amount extra_lump balance",
    )

    def __init__(
        self,
        principal=None,
        rate=None,
        number=None,
        periods=12,
        extra_amount=0,
        extra_lumps=None,
    ):
        self.principal = Decimal(principal)
        self.rate = Decimal(rate)
        self.number = int(number)
        self.original_number = int(number)
        self.periods = int(periods)
        self.extra_lumps = extra_lumps or {}
        self.extra_amount = Decimal(extra_amount)

        self._rate = self.rate / periods / 100
        self.payment_amount = self.calculate_payment_amount()
        self.payments = self.calculate_payments()
        self.original_payments = self.payments
        self.total_interest = self.calculate_total_interest()
        self.original_interest = self.total_interest
        self.interest_saved = Decimal("0.00")

        if self.extra_amount > 0 or len(self.extra_lumps) > 0:
            self.payments = self.calculate_payments(True)
            self.number = len(self.payments)
            self.total_interest = self.calculate_total_interest()

    def calculate_payment_amount(self):
        pmt_rate = (1 + self._rate) ** self.number
        pmt_numerator = self.principal * self._rate * pmt_rate
        pmt_denominator = pmt_rate - 1
        # FUTURE: round using Commodity#fraction
        return round(pmt_numerator / pmt_denominator, 2)

    def calculate_payments(self, include_extras=False):
        balance = self.principal
        payments = []
        payment_number = 0
        while balance > 0:
            payment_number += 1
            interest = round(balance * self._rate, 2)
            principal = self.payment_amount - interest
            balance = balance - principal
            extra_lump = Decimal("0.00")

            if include_extras and self.extra_amount > 0:
                balance = balance - self.extra_amount

            numstr = str(payment_number)
            if include_extras and numstr in self.extra_lumps:
                extra_lump = Decimal(self.extra_lumps[numstr])
                balance = balance - extra_lump

            if balance < 0:
                principal += balance
                balance = 0

            if payment_number == self.number:
                principal = principal + balance
                balance = 0

            payment = Amortization.Payment(
                number=payment_number,
                total=principal + interest + self.extra_amount + extra_lump,
                principal=principal,
                interest=interest,
                extra_amount=self.extra_amount,
                extra_lump=extra_lump,
                balance=balance,
            )

            payments.append(payment)
        return payments

    def calculate_total_interest(self):
        return sum([p.interest for p in self.payments])
