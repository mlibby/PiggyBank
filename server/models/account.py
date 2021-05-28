from enum import Enum, unique
from server.models.base import db


@unique
class AccountType(Enum):
    """Used to classify Account instances"""

    ASSET = 1
    EQUITY = 2
    EXPENSE = 3
    INCOME = 4
    LIABILITY = 5
    MORTGAGE = 6


class Account(db.Model):
    """
    Accounts represent a collection of ledger entries for
    assets, liabilities, income, expenses, and equity
    """

    id = db.Column(db.Integer, primary_key=True)
    account_type = db.Column(db.Enum(AccountType), nullable=False)
    commodity_id = db.Column(db.Integer, nullable=False)
    is_placeholder = db.Column(db.Boolean, nullable=False)
    name = db.Column(db.String(256), nullable=False)
    parent_id = db.Column(db.Integer, db.ForeignKey("account.id"))

    #breakpoint()
    subaccounts = db.relationship("Account")
    
    # one_to_many :subaccounts, class: self, key: :parent_id
    # many_to_one :parent, class: self
    # many_to_one :commodity, class: PiggyBank::Commodity
