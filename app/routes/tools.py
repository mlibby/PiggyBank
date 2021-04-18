#from .. import Amortization
from flask import Blueprint, render_template, request
from decimal import *


class Amortization:
    def __init__(self, principal, rate, number):
        self.principal = principal
        self.rate = rate
        self.number = number

        self.payments = []
        self.payment_amount = Decimal('0.00')


tools = Blueprint("tools", __name__, template_folder="templates")


@tools.route("/mortgage")
def index():
    context = {
        'title': 'Amortization: PiggyBank',
        'principal': 0,
        'rate': 0.0,
        'number': 1,
        'has_payments': False
    }

    if len(request.args) > 0:
        context['principal'] = principal = \
            Decimal(request.args.get('loan-amount'))
        context['rate'] = rate = \
            Decimal(request.args.get('rate'))
        context['number'] = number = \
            int(request.args.get('number'))
        #period = request.args.get('period')

        amortization = Amortization(principal, rate, number)
        context['has_payments'] = True
        context['payments'] = amortization.payments
        context['payment_amount'] = amortization.payment_amount

    return render_template("tools/mortgage.pug", **context)
