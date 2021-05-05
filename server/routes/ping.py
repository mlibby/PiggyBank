from flask import Blueprint, jsonify

ping = Blueprint('ping', __name__)

@ping.route('/ping')
def get_ping():
    return jsonify({'data': 'pong!'})
