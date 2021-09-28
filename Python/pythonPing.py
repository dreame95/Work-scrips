import socket
import sys
import os

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #should create a tcp/ip socket
server_ip = input('Enter Ip')
rep = os.system('ping ' + server_ip)

if rep == 0:
    print("server is up")
else:
    print("server is down")