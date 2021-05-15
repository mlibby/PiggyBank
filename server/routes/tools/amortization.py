from ...models import Amortization
from flask import Blueprint, jsonify, request
from decimal import Decimal

amortization = Blueprint('amortization', __name__)


@amortization.post('/')
def amortization_post():
    params = request.json
    principal = Decimal(params['principal'])
    rate = Decimal(params['rate'])
    number = int(params['number'])
    periods = int(params['periods'])
    amortization = Amortization(principal, rate, number)
    data = {
        'principal': principal,
        'rate': rate,
        'number': number,
        'periods': periods,
        'payments': [payment._asdict() for payment in amortization.payments],
        'total_interest': amortization.total_interest
        }
    return jsonify(data)

