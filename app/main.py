from flask import Flask, render_template
  
app = Flask(__name__)
app.jinja_env.add_extension('pyjade.ext.jinja.PyJadeExtension')
  
@app.route("/")
def home_view():
  return render_template('home/index.jade')