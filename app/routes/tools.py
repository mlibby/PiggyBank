from decimal import *
from flask import Blueprint, render_template, request
from ..models import Amortization
tools = Blueprint("tools", __name__, template_folder="templates")


@tools.route("/mortgage")
def index():
    context = {
        'title': 'Amortization: PiggyBank'
    }

    if len(request.args) > 0:
        principal = Decimal(request.args.get('loan-amount'))
        rate = Decimal(request.args.get('rate')) / 1200
        number = int(request.args.get('number'))
        #period = request.args.get('period')

        amortization = Amortization(principal, rate, number)
        context['payments'] = amortization.payments
        context['payment_amount'] = amortization.payment_amounts

    return render_template("tools/mortgage.pug", **context)
