from server import create_app
from server.models import db
from server.tests.models.reset_db import reset_db

def test_client():
    app = create_app("testing")
    with app.test_client() as client:
        reset_db(db)
        return client


def test_db():
    app = create_app("testing")
    app_context = app.app_context()
    app_context.push()
    reset_db(db)
    return app_context, db


def finalize(app_context, db):
    db.session.remove()
    app_context.pop()
