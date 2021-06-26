import unittest
import pytest
from decimal import Decimal
from server.util.json import PiggyBankJSONEncoder


class TestJson(unittest.TestCase):
    def test_default_for_decimal(self):
        encoder = PiggyBankJSONEncoder()
        assert encoder.default(Decimal("1.23")) == "1.23"
        assert encoder.default(Decimal("1.2")) == "1.20"
        assert encoder.default(Decimal("1")) == "1.00"
        assert encoder.default(Decimal("1.234")) == "1.23"

    def test_default_raises_exception_for_unknown_type(self):
        encoder = PiggyBankJSONEncoder()
        with pytest.raises(TypeError):
            encoder.default("foo")
