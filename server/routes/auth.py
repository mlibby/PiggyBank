from ..models import User
from flask import (
    Blueprint,
    abort,
    jsonify,
    request,
)
from flask_login import login_user


auth = Blueprint("auth", __name__)


@auth.post("/")
def auth_post():
    username = request.json["username"]
    password = request.json["password"]

    user = User.query.filter_by(username=username).first_or_404()
    if user.check_password(password):
        login_user(user)

    return jsonify(user.id)
