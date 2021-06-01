from decimal import Decimal
import pytest
from server.models import Amortization


thirty_year = Amortization(Decimal("100000"), Decimal("6.00"), 360)
fifteen_year = Amortization(Decimal("200000"), Decimal("3.25"), 180)


def test_amortization_payment_amount():
    assert thirty_year.payment_amount == Decimal("599.55")
    assert fifteen_year.payment_amount == Decimal("1405.34")


def test_amortization_payment_schedule():
    assert len(thirty_year.payments) == 360
    assert len(fifteen_year.payments) == 180


def test_amortization_final_payment():
    # has a balloon payment
    assert (
        thirty_year.payments[359].principal + thirty_year.payments[359].interest
    ) == Decimal("600.00")
    # has a slightly smaller payment
    assert (
        fifteen_year.payments[179].principal + fifteen_year.payments[179].interest
    ) == Decimal("1404.95")


def test_amortization_total_interest():
    assert thirty_year.total_interest == Decimal("115838.45")
    assert fifteen_year.total_interest == Decimal("52960.81")


def test_amortization_prepay_amount():
    thirty_year = Amortization(
        principal="100000",
        rate="6.00",
        number=360,
        extra_amount="100",
    )
    assert thirty_year.number == 252
    assert thirty_year.original_number == 360
    assert thirty_year.payments[-1].principal == Decimal("249.24")
    assert thirty_year.total_interest == Decimal("75938.04")
    assert thirty_year.original_interest == Decimal("115838.45")


def test_amortization_prepays():
    fifteen_year = Amortization(
        principal="200000",
        rate="3.25",
        number=180,
        extra_lumps={"2": "10000", "3": "5000", "4": "2000"},
    )
    assert fifteen_year.number == 161
    assert fifteen_year.original_number == 180
    assert fifteen_year.payments[-1].principal == Decimal("1295.96")
    assert fifteen_year.total_interest == Decimal("43153.87")
    assert fifteen_year.original_interest == Decimal("52960.81")
