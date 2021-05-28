from ..models import Account
from flask import Blueprint, jsonify

account = Blueprint("account", __name__)


@account.get("/")
def account_index_get():
    account_tree = Account.get_account_tree()
    return jsonify(account_tree)
