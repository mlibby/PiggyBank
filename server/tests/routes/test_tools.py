import unittest
from server.tests import client

class TestToolsAmortization(unittest.TestCase):
    def setUp(self):
        self.client = client()
    
    def test_tools_amortization(self):
        input = {
            "principal": "225000",
            "rate": "4.25",
            "number": "360",
            "periods": "12",
            "extra_amount": "0",
            "extra_lumps": {},
        }
        page = self.client.post("/api/tools/amortization", json=input)
        data = page.data.decode()
        assert "payments" in data
