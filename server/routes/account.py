from ..models import Account, AccountType
from flask import Blueprint, jsonify, abort

account = Blueprint("account", __name__)

@account.get("/")
def accounts_get():
    accounts = [
        dict(account)
        for account
        in Account.query.all()
        ]
    return jsonify(accounts)

@account.get("/tree")
def account_tree_get():
    account_tree = Account.get_account_tree()
    return jsonify(account_tree)

@account.get("/types")
def account_types_get():
    account_types = list(AccountType)
    return jsonify(account_types)

@account.get("/<int:account_id>")
def account_get(account_id):
    account = Account.query.get(account_id)
    return jsonify(dict(account))
