from flask import Flask, render_template, request
import subprocess
import os
import time
from threading import Thread
import fileinput

app = Flask(__name__)
app.debug = True


def set_wifi_credentials(ssid, password):
    return True


@app.route("/save_credentials", methods=["GET", "POST"])
def save_credentials():
    ssid = request.json["ssid"]
    wifi_key = request.json["wifi_key"]

    if set_wifi_credentials(ssid, wifi_key):
        return {"status": "success", "status_code": 200}
    else:
        return {"status": "failed", "status_code": 500}


@app.route("/connected", methods=["GET", "POST"])
def conncected():
    response = {"status_code": 200}
    return response


app.run(host="0.0.0.0", port=5000)