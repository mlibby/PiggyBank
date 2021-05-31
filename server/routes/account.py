from ..models import Account, AccountType, db
from flask import (
    Blueprint,
    abort,
    jsonify,
    request,
)

account = Blueprint("account", __name__)


@account.get("/")
def accounts_get():
    accounts = [dict(account) for account in Account.query.all()]
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
    account = Account.query.get_or_404(account_id)
    return jsonify(dict(account))


@account.post("/<int:account_id>")
def account_post(account_id):
    account = Account.query.get_or_404(account_id)

    account.name = request.json["name"]
    account.account_type = request.json["account_type"]
    account.is_placeholder = request.json["is_placeholder"]
    account.commodity_id = request.json["commodity_id"]
    account.parent_id = request.json["parent_id"]

    db.session.commit()
    
    return jsonify(dict(account))
