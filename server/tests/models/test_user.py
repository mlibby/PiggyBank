import unittest
from server.models import User
from server.tests import test_db, finalize
from server.tests.models.reset_db import reset_db


class TestCommodity(unittest.TestCase):
    def setUp(self):
        self.app_context, self.db = test_db()

    def tearDown(self):
        finalize(self.app_context, self.db)

    def test_user_get(self):
        pass
        #user = User.query.filter_by(username="foobar").first()
        #assert user is not None

