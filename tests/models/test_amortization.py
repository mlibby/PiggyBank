from decimal import Decimal
import unittest
from app.models import Amortization


def test_payment_amount():
    amort = Amortization(Decimal('100000'), Decimal('6.00'), 360)
    assert amort.payment_amount == Decimal('599.55')


def test_payment_schedule():
    amort = Amortization(Decimal('100000'), Decimal('6.00'), 360)
    assert len(amort.payments) == 360


def test_balloon_payment():
    amort = Amortization(Decimal('100000'), Decimal('6.00'), 360)
    assert amort.payments[359]['total'] == Decimal('600.00')


if __name__ == "__main__":
    unittest.main()
