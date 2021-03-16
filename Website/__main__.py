from flask import Flask
import socket

webapp = Flask("Team2")

@webapp.route("/")
def print_private_ip():
    ip = socket.gethostbyname(socket.gethostname())
    return "My Private IP is: {}".format(ip)

webapp.run("0.0.0.0", 80)




