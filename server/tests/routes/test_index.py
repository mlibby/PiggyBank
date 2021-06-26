import unittest
from server.tests import client


class TestIndex(unittest.TestCase):
    def test_default_page(self):
        page = client.get("/")
        html = page.data.decode()
        
        assert "<html" in html


    def test_favicon(self):
        page = client.get("/favicon.ico")
        assert page.status == "200 OK"
