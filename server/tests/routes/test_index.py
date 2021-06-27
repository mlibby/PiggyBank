import unittest
from server.tests import test_client


class TestIndex(unittest.TestCase):
    def setUp(self):
        self.client = test_client()

    def test_default_page(self):
        page = self.client.get("/")
        html = page.data.decode()
        assert "<html" in html

    def test_favicon(self):
        page = self.client.get("/favicon.ico")
        assert page.status == "200 OK"
