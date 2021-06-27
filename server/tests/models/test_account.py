import unittest
from server.models import Account, AccountType
from server.tests import test_db, finalize
from server.tests.models.reset_db import reset_db


class TestAccount(unittest.TestCase):
    def setUp(self):
        self.app_context, self.db = test_db()
        reset_db(self.db)

    def tearDown(self):
        finalize(self.app_context, self.db)

    def test_account_get(client):
        account = Account.query.filter_by(name="Assets").first()
        assert account is not None
        assert account.account_type == AccountType.ASSET
