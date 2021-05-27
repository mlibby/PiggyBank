from server.models.base import db


class Account(db.Model):
    """
    Assets, liabilities, income, expenses, and equity
    """

    id = db.Column(db.Integer, primary_key=True)
    parent_id = db.Column(db.Integer)
    name = db.Column(db.String(256), nullable=False)
    is_placeholder(db.Boolean, nullable=False)
    type = db.Column(db.Integer, nullable=False)
    """
      asset: 1,
      liability: 2,
      equity: 3,
      income: 4,
      expense: 5,
      mortgage: 6,
    """

    # one_to_many :subaccounts, class: self, key: :parent_id
    # many_to_one :parent, class: self
    # many_to_one :commodity, class: PiggyBank::Commodity
