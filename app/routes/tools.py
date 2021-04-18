from ..models import Amortization
from flask import Blueprint, render_template, request
from decimal import *


tools = Blueprint("tools", __name__, template_folder="templates")


@tools.route("/amortization")
def amortization():
    context = {
        'title': 'Amortization: PiggyBank',
        'principal': 0,
        'rate': 0.0,
        'number': 1,
        'has_payments': False
    }

    if len(request.args) > 0:
        principal = Decimal(request.args.get('principal'))
        rate = Decimal(request.args.get('rate'))
        number = int(request.args.get('number'))
        #period = request.args.get('period')

        amortization = Amortization(principal, rate, number)
        context['principal'] = principal
        context['rate'] = rate
        context['number'] = number
        context['has_payments'] = True
        context['payments'] = amortization.payments
        context['payment_amount'] = amortization.payment_amount

    return render_template("tools/amortization.pug", **context)
