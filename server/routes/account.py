from ..models import Account
from flask import Blueprint, jsonify, abort

account = Blueprint("account", __name__)


@account.get("/")
def account_index_get():
    account_tree = Account.get_account_tree()
    return jsonify(account_tree)


@account.get("/<int:account_id>")
def account_get(account_id):
    account = Account.query.get(account_id)
    return jsonify(dict(account))
