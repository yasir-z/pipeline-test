from flask import Flask, jsonify

app = Flask(__name__)


def get_status():
    return "running"


@app.route("/")
def home():
    return jsonify({
        "message": "Hello from Jenkins CI/CD!",
        "status": get_status()
    })


@app.route("/health")
def health():
    return jsonify({"status": "healthy"}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
