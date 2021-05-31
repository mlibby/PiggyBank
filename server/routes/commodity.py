from ..models import Commodity, CommodityType
from flask import Blueprint, jsonify

commodity = Blueprint("commodity", __name__)

@commodity.get("/")
def commodities_get():
    commodities = [
        dict(commodity)
        for commodity
        in Commodity.query.all()
        ]
    return jsonify(commodities)

