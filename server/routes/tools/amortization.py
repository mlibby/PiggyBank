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
    extra_amount = Decimal(params['extra_amount'])
    extra_lumps = params['extra_lumps']

    amortization = Amortization(
        principal,
        rate,
        number,
        periods,
        extra_amount,
        extra_lumps
    )

    data = {
        'extra_amount': amortization.extra_amount,
        'number': amortization.number,
        'original_interest': amortization.original_interest,
        'original_number': amortization.original_number,
        'payment_amount': amortization.payment_amount,
        'payments': [payment._asdict() for payment in amortization.payments],
        'periods': periods,
        'principal': principal,
        'rate': rate,
        'total_interest': amortization.total_interest,
    }
    return jsonify(data)
