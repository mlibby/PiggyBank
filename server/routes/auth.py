from ..models import User
from flask import (
    Blueprint,
    abort,
    jsonify,
    request,
)
from flask_login import login_user, logout_user


auth = Blueprint("auth", __name__)


@auth.post("/sign-in")
def sign_in():
    username = request.json["username"]
    password = request.json["password"]

    user = User.query.filter_by(username=username).first_or_404()
    if user.check_password(password):
        login_user(user)
        return "signed in"
    else:
        return ("Username and password do not match", 401)

@auth.post("/sign-out")
def sign_out():
    logout_user()
    return "signed out"
