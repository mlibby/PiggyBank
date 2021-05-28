from enum import Enum, unique
from server.models.base import db


@unique
class CommodityType(Enum):
    """How to manage values in Commodity"""

    CURRENCY = 1
    INVESTMENT = 2


class Commodity(db.Model):
    """Tracks a currency or investment"""

    id = db.Column(db.Integer, primary_key=True)
    commodity_type = db.Column(db.Enum(CommodityType), nullable=False)
    name = db.Column(db.String(256), nullable=False)
    description = db.Column(db.String(256), nullable=False)
    ticker = db.Column(db.String(256))
    """Symbol to use for price lookups"""

    fraction = db.Column(db.Integer)
    """How many decimal places to round values to when storing"""
