from decimal import Decimal
import pytest
from app.models import Amortization


thirty_year = Amortization(Decimal('100000'), Decimal('6.00'), 360)
fifteen_year = Amortization(Decimal('200000'), Decimal('3.25'), 180)


def test_amortization_payment_amount():
    assert thirty_year.payment_amount == Decimal('599.55')
    assert fifteen_year.payment_amount == Decimal('1405.34')


def test_amortization_payment_schedule():
    assert len(thirty_year.payments) == 360
    assert len(fifteen_year.payments) == 180


def test_amortization_final_payment():
    # has a balloon payment
    assert thirty_year.payments[359]['total'] == Decimal('600.00')
    # has a slightly smaller payment
    assert fifteen_year.payments[179]['total'] == Decimal('1404.95')


def test_amortization_total_interest():
    assert thirty_year.total_interest() == Decimal('115838.45')
    assert fifteen_year.total_interest() == Decimal('52960.81')
