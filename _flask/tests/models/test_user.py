from flask_testing import TestCase
from server import create_app
from server.models import db, User
from server.tests.models.reset_db import reset_db


class TestCommodity(TestCase):
    def create_app(self):
        return create_app("testing")

    def setUp(self):
        db.create_all()
        reset_db(db)

    def tearDown(self):
        db.session.remove()
        db.drop_all()

    def test_user_get(self):
        user = User.query.filter_by(username="foobar").first()
        assert user is not None
