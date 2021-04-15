from flask import Flask, render_template

app = Flask(__name__)
app.jinja_env.add_extension('pypugjs.ext.jinja.PyPugJSExtension')


@app.route("/")
def home_view():
    return render_template('home/index.pug')


@app.route("/foo")
def foo_view():
    return "foo bar"
