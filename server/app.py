from flask import (
    Blueprint,
    Flask,
    render_template,
    request,
    send_from_directory,
)
from flask_login import LoginManager
from flask_migrate import Migrate
from server.models import db
from server.models import User
from server.routes.account import account
from server.routes.commodity import commodity
from server.routes.tools.amortization import amortization
from server.routes.auth import auth
from server.util.json import PiggyBankJSONEncoder

app = Flask(
    __name__,
    static_url_path="/static",
    static_folder="static",
    template_folder="templates",
)

app.url_map.strict_slashes = False
app.json_encoder = PiggyBankJSONEncoder
app.config.from_object("server.config.Config")

db.init_app(app)
migrate = Migrate(app, db)

login_manager = LoginManager()
login_manager.init_app(app)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.errorhandler(404)
def handle_404(e):
    if (
        request.path.startswith("/api")
        or request.path.startswith("/static")
        or request.path.startswith("/s2")
    ):
        return e
    else:
        return render_template("index.html")


@app.get("/favicon.ico")
def get_favicon():
    return send_from_directory("./templates/s2", "favicon.ico")


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
