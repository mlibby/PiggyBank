from ...models import Amortization
from flask import Blueprint, render_template, request
from decimal import *


amortization = Blueprint("amortization", __name__, template_folder="templates")


@amortization.route("/", methods=['GET'])
def amortization_new():
    context = {
        'title': 'Amortization: PiggyBank',
        'principal': 0,
        'rate': 0.0,
        'number': 1,
        'has_payments': False
    }
    return render_template("tools/amortization.pug", **context)


@amortization.route("/", methods=['POST'])
def amortization_edit():
    context = {
        'title': 'Amortization: PiggyBank',
        'principal': Decimal(request.values.get('principal')),
        'rate': Decimal(request.values.get('rate')),
        'number': int(request.values.get('number')),
        'has_payments': True
    }

    amortization = Amortization(
        context['principal'],
        context['rate'],
        context['number']
    )
    context['payments'] = amortization.payments
    context['payment_amount'] = amortization.payment_amount

    return render_template("tools/amortization.pug", **context)
