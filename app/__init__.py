from flask import Flask, render_template
# from ..repo import Repo
from .routes import (
    home,
    #    accounts,
    #    budget,
    #    commodities,
    #    dashboard,
    #    ledger,
    #    ofx,
    #    prices,
    #    reports
)

app = Flask(__name__,
            static_url_path='',
            static_folder='static',
            template_folder='templates')

app.jinja_env.add_extension('pypugjs.ext.jinja.PyPugJSExtension')
app.url_map.strict_slashes = False

# @home.before_app_first_request
# def update_db():
#     repo = Repo()
#     repo.update_db()


app.register_blueprint(home)
# app.register_blueprint(accounts, url_prefix="/accounts")
# app.register_blueprint(budget, url_prefix="/budget")
# app.register_blueprint(commodities, url_prefix="/commodities")
# app.register_blueprint(dashboard, url_prefix="/dashboard")
# app.register_blueprint(ledger, url_prefix="/ledger")
# app.register_blueprint(ofx, url_prefix="/ofx")
# app.register_blueprint(prices, url_prefix="/prices")
# app.register_blueprint(reports, url_prefix="/reports")
