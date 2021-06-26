from flask import (
    Blueprint,
    Flask,
    render_template,
    request,
    send_from_directory,
)
from flask_login import LoginManager
from flask_migrate import Migrate
from config import config
from server.login_manager import login_manager
from server.models import db
from server.routes.account import account
from server.routes.auth import auth
from server.routes.commodity import commodity
from server.routes.tools.amortization import amortization
from server.util.json import PiggyBankJSONEncoder

def create_app(config_name):
    app = Flask(
        __name__,
        static_url_path="/static",
        static_folder="static",
        template_folder="templates",
    )

    app.url_map.strict_slashes = False
    app.json_encoder = PiggyBankJSONEncoder
    app.config.from_object(config[config_name])

    db.init_app(app)
    migrate = Migrate(app, db)
    login_manager.init_app(app)

    register_blueprints(app)
    set_404_handler(app)
    set_favicon_handler(app)

    return app


def set_404_handler(app):
    app.register_error_handler(404, handle_404)


def handle_404(e):
    if (
        request.path.startswith("/api")
        or request.path.startswith("/static")
        or request.path.startswith("/s2")
    ):
        breakpoint()
        return e
    else:
        return render_template("index.html")


def set_favicon_handler(app):
    app.add_url_rule("/favicon.ico", view_func=get_favicon)


def get_favicon():
    return send_from_directory("./templates/s2", "favicon.ico")


def register_blueprints(app):
    s2 = Blueprint(
        "s2",
        __name__,
        static_url_path="/s2",
        static_folder="./templates/s2",
    )
    app.register_blueprint(s2)

    app.register_blueprint(account, url_prefix="/api/account")
    app.register_blueprint(auth, url_prefix="/api/auth")
    app.register_blueprint(commodity, url_prefix="/api/commodity")
    app.register_blueprint(amortization, url_prefix="/api/tools/amortization")
