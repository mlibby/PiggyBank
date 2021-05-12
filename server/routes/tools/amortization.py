from ...models import Amortization
from flask import Blueprint, jsonify, request
from decimal import Decimal

amortization = Blueprint("amortization", __name__)


@amortization.post("/")
def amortization_post():
    params = request.json
    principal = Decimal(params['principal'])
    rate = Decimal(params['rate'])
    number = int(params['number'])
    amortization = Amortization(principal, rate, number)
    return jsonify([payment._asdict() for payment in amortization.payments])

