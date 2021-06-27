import unittest
from server.tests import test_client


class TestRootRoutes(unittest.TestCase):
    def setUp(self):
        self.client = test_client()

    def test_root_route(self):
        page = self.client.get("/")
        html = page.data.decode()
        assert "<html" in html

    def test_favicon_route(self):
        page = self.client.get("/favicon.ico")
        assert page.status == "200 OK"
