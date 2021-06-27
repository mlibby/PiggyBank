import unittest
from server.tests import test_client


class TestAccountRoutes(unittest.TestCase):
    def setUp(self):
        self.client = test_client()

    def test_account_get(self):
        page = self.client.get("/api/account")
        assert page.content_type == "application/json"

    def test_account_tree_get(self):
        page = self.client.get("/api/account/tree")
        assert page.content_type == "application/json"

    def test_account_get_types(self):
        page = self.client.get("/api/account/types")
        assert page.content_type == "application/json"

    def test_account_put(self):
        data = dict(name="test")
        page = self.client.put("/api/account", data=data)
        assert page.content_type == "application/json"

    def test_account_post(self):
        data = dict(name="test")
        page = self.client.post("/api/account/1", data=data)
        assert page.content_type == "application/json"

    def test_account_delete(self):
        data = dict(name="test")
        page = self.client.delete("/api/account/1", data=data)
        assert page.content_type == "application/json"
