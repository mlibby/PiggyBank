from flask import Flask
  
app = Flask(__name__)
  
@app.route("/")
def home_view():
  return "temporarily unavailable, back soon!"