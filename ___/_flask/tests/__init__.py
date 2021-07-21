from flask_sqlalchemy import SQLAlchemy
from server import create_app
#from server.models import db
from server.tests.models.reset_db import reset_db

def test_client():
    app = create_app("testing")
    db = SQLAlchemy()
    with app.test_client() as client:
        db.init_app(app)
        reset_db(db)
        return client


def finalize(app_context, db):
    db.session.remove()
    app_context.pop()
