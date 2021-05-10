from ...models import Amortization
from flask import Blueprint, jsonify, request
from decimal import Decimal

amortization = Blueprint("amortization", __name__)


@amortization.route("/", methods=['POST'])
def amortization_post():
    amount = Decimal('100000')
    rate = Decimal('3.25')
    payments = int('60')
    amortization = Amortization(amount, rate, payments)
    return jsonify(amortization.payments)

