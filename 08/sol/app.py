from flask import Flask, jsonify

app = Flask(__name__)
app.config.from_object(__name__)


@app.route('/', methods=['GET'])
def hello_world():
    return jsonify('Hello World')


if __name__ == '__main__':
    app.run('0.0.0.0', '5000', 'true')
