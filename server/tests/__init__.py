from server import create_app
from server.models import db

def test_client():
    app = create_app("testing")
    with app.test_client() as client:
        return client


def test_db():
    app = create_app("testing")
    app_context = app.app_context()
    app_context.push()
    return app_context, db


def finalize(app_context, db):
    db.session.remove()
    app_context.pop()
