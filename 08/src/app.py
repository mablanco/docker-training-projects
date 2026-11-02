from flask import Flask, jsonify

app = Flask(__name__)


@app.route('/', methods=['GET'])
def hello_world():
    return jsonify('Hello World')
