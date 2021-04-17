from flask import Blueprint, render_template

home = Blueprint("", __name__, template_folder="templates")


@home.route("/")
def index():
    return render_template("home/index.pug", title="PiggyBank")
