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
    prepay_amount = Decimal(params['prepay_amount'])
    prepays = params['prepays']

    amortization = Amortization(
        principal,
        rate,
        number,
        periods,
        prepay_amount,
        prepays
    )

    data = {
        'principal': principal,
        'rate': rate,
        'number': amortization.number,
        'periods': periods,
        'payments': [payment._asdict() for payment in amortization.payments],
        'total_interest': amortization.total_interest,
        'original_interest': amortization.original_interest,
        'original_number': amortization.original_number
        }
    return jsonify(data)

