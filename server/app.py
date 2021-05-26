from flask import Blueprint, Flask, render_template, send_from_directory
from .util.json import PiggyBankJSONEncoder
from .routes.tools.amortization import amortization

app = Flask(
    __name__,
    static_url_path="/static",
    static_folder="static",
    template_folder="templates",
)

app.url_map.strict_slashes = False
app.json_encoder = PiggyBankJSONEncoder


@app.errorhandler(404)
def handle_404(e):
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

app.register_blueprint(amortization, url_prefix="/api/tools/amortization")
