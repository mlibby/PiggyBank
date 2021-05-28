from enum import Enum, unique
from server.models.base import db


@unique
class AccountType(str, Enum):
    """Used to classify Account instances"""

    ASSET = "ASSET"
    EQUITY = "EQUITY"
    EXPENSE = "EXPENSE"
    INCOME = "INCOME"
    LIABILITY = "LIABILITY"
    MORTGAGE = "MORTGAGE"


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

    subaccounts = db.relationship("Account", foreign_keys=[parent_id])

    @classmethod
    def get_account_tree(cls):
        accounts = cls.get_subaccounts(None)
        return accounts

    @classmethod
    def get_subaccounts(cls, parent_id):
        accounts = cls.query.filter_by(parent_id=parent_id).all()
        account_list = []
        for account in accounts:
            account_dict = dict(account)
            if len(account.subaccounts) > 0:
                account_dict['subaccounts'] = cls.get_subaccounts(account.id)
            account_list.append(account_dict)
        return account_list
    
    # one_to_many :subaccounts, class: self, key: :parent_id
    # many_to_one :parent, class: self
    # many_to_one :commodity, class: PiggyBank::Commodity

    def __iter__(self):
        column_names = [column.name for column in self.__table__.columns]
        for column in column_names:
            yield column, getattr(self, column)

    def __repr__(self):
        return f"<Account {self.id}:'{self.name}'>"
