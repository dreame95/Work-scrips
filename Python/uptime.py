import paramiko
import sys
from decimal import *

def checkUptime(hostIP, passW):

    target_host = hostIP
    ssh_client = paramiko.SSHClient()
    check_time = 0

    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(hostname = target_host,username='pi',password=passW)

    stdin,stdout,stderr = ssh_client.exec_command("cat /proc/uptime")

    result = str(stdout.read())
    result = result.split(' ',1)[0]
    result_temp = result[2:]
    result_int = float(result_temp) / 60
    if float(result_int) > check_time:
        print("it rebooted", Decimal(result_int).quantize(Decimal('.01')), " minutes ago")
    ssh_client.close()

if __name__ == "__main__":
    hostIP = str(sys.argv[1])
    passW = str(sys.argv[2])
    checkUptime(hostIP, passW)
    