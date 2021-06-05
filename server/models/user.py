from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from server.models.base import db


class User(UserMixin, db.Model):
    """
    User represents a person with access to the application
    """

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(32), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
