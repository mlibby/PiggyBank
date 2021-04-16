from flask import Blueprint, render_template
# from ..repo import Repo        

home = Blueprint("", __name__, template_folder="templates")

# @home.before_app_first_request
# def update_db():
#     repo = Repo()
#     repo.update_db()

@home.route("/")
def index():
    return render_template("home/index.pug", title="PiggyBank")
