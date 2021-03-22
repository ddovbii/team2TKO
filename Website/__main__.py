from flask import Flask
import socket
import os

CON_STR = os.getenv("connection_string", None)

webapp = Flask("Team2")

@webapp.route("/")
def print_private_ip():
    msg = ""
    ip = socket.gethostbyname(socket.gethostname())
    msg += "My Private IP is: {}".format(ip)
    if CON_STR:
        msg += "\nConnection String: {}".format(CON_STR)
    msg += "team2"
    return msg

webapp.run("0.0.0.0", 80)




