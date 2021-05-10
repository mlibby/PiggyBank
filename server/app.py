from flask import Flask, render_template
from .util.json import PiggyBankJSONEncoder
# from ..repo import Repo
from .routes.tools.amortization import amortization

#home,
#ping,
#    accounts,
#    budget,
#    commodities,
#    dashboard,
#    ledger,
#    ofx,
#    prices,
#    reports
#    amortization,
#)

app = Flask(__name__,
            static_url_path='/static',
            static_folder='static',
            template_folder='templates')

app.url_map.strict_slashes = False
app.json_encoder = PiggyBankJSONEncoder
# @home.before_app_first_request
# def update_db():
#     repo = Repo()
#     repo.update_db()

@app.errorhandler(404)
def handle_404(e):
    return render_template('index.html')

# app.register_blueprint(accounts, url_prefix="/accounts")
# app.register_blueprint(budget, url_prefix="/budget")
# app.register_blueprint(commodities, url_prefix="/commodities")
# app.register_blueprint(dashboard, url_prefix="/dashboard")
# app.register_blueprint(ledger, url_prefix="/ledger")
# app.register_blueprint(ofx, url_prefix="/ofx")
# app.register_blueprint(prices, url_prefix="/prices")
# app.register_blueprint(reports, url_prefix="/reports")
app.register_blueprint(amortization, url_prefix='/api/tools/amortization')
