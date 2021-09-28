import PySimpleGUI as sg
import time
import sys, os
import schedule
import paramiko
from decimal import *

# ping function to ping each device
def pinger(address):
    clearList()
    # function to pin a list of IP's
    for i in range(len(address)):
        pingResponse = os.system("ping -n 1 -w 1000 " + address[i])
        #pingResponse = os.system("ping -c 1 -W 1 " + address[i])

        # if a response is recived set state to connected
        if pingResponse == 0:
            print('Status is connected')
            state='Connected'
            pingSuccess = True

        # if a response is not recived set state to not connected
        else:
            print('Not Connected')
            state='Not Connected'
            pingSuccess = False

        #create dictionary to store IP and state
        host_and_states.update({address[i] : state})
        print(address[i] + ' : ' + host_and_states[address[i]])
        print(i)

        # attempt to check if video process is running
        if pingSuccess == True:
            checkProcess(address[i])





# function to get open ssh client and returns the uptime
def getUptime(address):
    
    # get the address and set the info for SSH client
    target_host = address
    ssh_client = paramiko.SSHClient()
    check_time = 0

    # connect to the host
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(hostname = target_host, username='pi', password='lemonBattery')
    
    # Run the command to get the uptime
    stdin,stdout,stderr = ssh_client.exec_command("cat /proc/uptime")

    # save the output and format it to be readable
    result = str(stdout.read())
    result = result.split(' ',1)[0]
    result_temp = result[2:]
    result_int = float(result_temp) / 60
    if float(result_int) > check_time:
        uptime_message = ("rebooted: " + str(Decimal(result_int).quantize(Decimal('.01')))  + " minutes ago")
    
    # Close the client
    ssh_client.close()
    return uptime_message

# function to open ssh client and sends a reboot command
def sendReboot(address):
    # get the address and set the info for SSH Client
    target_host = address
    ssh_client = paramiko.SSHClient()

    # connect to the host
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(hostname = target_host, username='pi', password='lemonBattery')

    # run the command to initiate reboot
    stdin,stdout,stderr = ssh_client.exec_command("sudo reboot")       

    # close the client
    ssh_client.close()
    # sleep 10 seconds P.S THIS IS BAD NEED TO FIGURE OUT A WAY TO NOT USE SLEEP
    time.sleep(10)

    # call the ping fucntion
    pinger(addresses)

def updateVideos(address):
    target_host = address
    ssh_client = paramiko.SSHClient()

    try:
        #connect to the host
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh_client.connect(hostname = target_host, username='pi', password='lemonBattery')

        stdin,stdout,stderr = ssh_client.exec_command('python /home/pi/bin/VideoScraper.py')
        stdin,stdout,stderr = ssh_client.exec_command('sudo reboot')
    except:
        print('couldn\'t connect')
def checkProcess(address):
    # get the address and set the info for SSH Client
    target_host = address
    ssh_client = paramiko.SSHClient()
    # clear the list for state of videos
    try:

    # connect to the host
        ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh_client.connect(hostname = target_host, username='pi', password='lemonBattery')

    # run the command to check if the 
        stdin,stdout,stderr = ssh_client.exec_command('ps aux | grep omxplayer')
        output = str(stdout.read())

    # close the client
        ssh_client.close()

    # check the length of the output to determine
    # if video is running
        if len(output) > 180:
            response = 'Video is running'
            video_states.append('Running')
        else:
            response = 'Video is not running'
            video_states.append('Not')
        return response
    except: 
        video_states.append('Not')

def clearList():
    print('Clearing list: ' + str(len(video_states)))
    video_states.clear()
    print('List Cleared: ' + str(len(video_states)))



addresses = ['192.168.110.47','192.168.110.56', '192.168.120.19', '192.168.110.91']    #list of addresses of devices
host_and_states = {}    # dictionary to store the host IP and the state(connected/Not Connected)
uptime_message = ''
state=''
video_states = []
pinger(addresses)   # pings the addresses initially
pingSuccess = False

# add a touch of color
sg.theme('Dark')



# the layout of the window ie. Buttons, textboxes, and lables
layout = [ [sg.Text('Hosts that have been pinged.')],
            [sg.Text('WMHVision-Cafe', size=(21,1)), sg.Text(addresses[0]+': '), sg.Text('Checking Status', size=(15,1), key='_Text0_'), sg.Button(' ', key='isRunning0', size=(2,1))
            ,sg.Button('Get Uptime', key='uptime1'), sg.Button('Force Restart', key='Restart1'), sg.Button('Check Video', key='video1')],
            [sg.Text('WMHVision-UrgentCare', size=(21,1)), sg.Text(addresses[1]+': '), sg.Text('Checking Status', size=(15,1), key='_Text1_'), sg.Button(' ', key='isRunning1', size=(2,1))
            ,sg.Button('Get Uptime', key='uptime2'), sg.Button('Force Restart', key='Restart2'), sg.Button('Check Video', key='video2')],
            [sg.Text('Pi Monitor', size=(21,1)), sg.Text(addresses[2]+': '), sg.Text('Checking Status', size=(15,1), key='_Text2_'), sg.Button(' ', key='isRunning2', size=(2,1))
            ,sg.Button('Get Uptime', key='uptime3'), sg.Button('Force Restart', key='Restart3'), sg.Button('Check Video', key='video3')],
            [sg.Text('WMHVision-SHC', size=(21,1)), sg.Text(addresses[3]+': '), sg.Text('Checking Status', size=(15,1), key='_Text3_'), sg.Button(' ', key='isRunning3', size=(2,1)),
            sg.Button('Get Uptime', key='uptime4'), sg.Button('Force Restart', key='Restart4'), sg.Button('Check Video', key='video4')],
            [ sg.Button('Cancel'), sg.Button('Force Check'), sg.Button('Clear'), sg.Button('Force Update', key='_update')],
            [sg.Text(' ', size = (50, 15), key='error')]]

# Create the Window
#window = sg.Window('WMHVision Monitor', layout)
#window.Maximize()
window = sg.Window('Ping Monitor', layout, location=(0,0), size=(900,600)).Finalize()

# schedules the ping function to run every 15 minutes
schedule.every(5).minutes.do(pinger, addresses)

print(video_states)
# Event Loop to process "events" and get the "values" of the inputs
is_running = True
while True:
    
    event, values = window.read(timeout=200)
    if event in (None, 'Cancel'):   # if user closes window or clicks cancel
        break
    if is_running:
        if len(video_states) >  len(video_states):
            print('something is wrong')
        else: 
            print(len(video_states))
        for i in range(len(addresses)):
            window['_Text' + str(i) + '_'].Update(host_and_states[addresses[i]])
            if video_states[i] == 'Running':
                window['isRunning' + str(i)].Update(visible=True)
            else:
                window['isRunning' + str(i)].Update(visible=False)

        schedule.run_pending()
    if event == 'Force Check':
        video_states.clear()
        pinger(addresses)

    #UPTIME BUTTONS
    if event == 'uptime0':
        sg.popup('Checking Uptime', auto_close=True, auto_close_duration=2)
        try:
            uptime_message = getUptime(addresses[0])
            window['error'].Update(uptime_message)
            checkProcess(addresses[0])
        except:
            window['error'].Update('FAILED... IS THE DEVICE CONNECTED')
    elif event == 'uptime1':
        sg.popup('Checking Uptime', auto_close=True, auto_close_duration=2)
        try:
            uptime_message = getUptime(addresses[1])
            window['error'].Update(uptime_message)
        except:
            window['error'].Update('FAILED... IS THE DEVICE CONNECTED')
    elif event == 'uptime2':
        sg.popup('Checking Uptime', auto_close=True, auto_close_duration=2)
        try:    
            uptime_message = getUptime(addresses[2])
            window['error'].Update(uptime_message)
        except:
            window['error'].Update('FAILED... IS THE DEVICE CONNECTED')
    elif event == 'uptime3':
        sg.popup('Checking Uptime', auto_close=True, auto_close_duration=2)
        try:    
            uptime_message = getUptime(addresses[3])
            window['error'].Update(uptime_message)
        except:
            window['error'].Update('FAILED... IS THE DEVICE CONNECTED')
    elif event == 'uptime4':
        sg.popup('Checking Uptime', auto_close=True, auto_close_duration=2)
        try:    
            uptime_message = getUptime(addresses[4])
            window['error'].Update(uptime_message)
        except:
            window['error'].Update('FAILED... IS THE DEVICE CONNECTED')
    #RESTART BUTTONS
    if event == 'Restart0':
        sg.popup('Sending Restart', auto_close=True, auto_close_duration=2)
        try: 
            sendReboot(addresses[0])
        except:
            window['error'].Update('FAILED CAN\'T CONNECT TO DEVICE')
    elif event == 'Restart1':
        sg.popup('Sending Restart', auto_close=True, auto_close_duration=2)
        try:    
            sendReboot(addresses[1])
        except:
            window['error'].Update('FAILED CAN\'T CONNECT TO DEVICE')
    elif event == 'Restart2':
        sg.popup('Sending Restart', auto_close=True, auto_close_duration=2)
        try: 
            sendReboot(addresses[2])
        except:
            window['error'].Update('FAILED CAN\'T CONNECT TO DEVICE')
    elif event == 'Restart3':
        sg.popup('Sending Restart', auto_close=True, auto_close_duration=2)
        try:
            sendReboot(addresses[3])
        except:
            window['error'].Update('FAILED CAN\'T CONNECT TO DEVICE')
    elif event == 'Restart4':
        sg.popup('Sending Restart', auto_close=True, auto_close_duration=2)
        try:
            sendReboot(addresses[4])
        except:
            window['error'].Update('FAILED CAN\'T CONNECT TO DEVICE')
    #CHECK VIDEO BUTTONS
    if event == 'video0':
        sg.popup('Checking if video is playing', auto_close=True, auto_close_duration=2)
        response = checkProcess(addresses[0])
        window['error'].Update(response)
    elif event == 'video1':
        sg.popup('Checking if video is playing', auto_close=True, auto_close_duration=2)
        response = checkProcess(addresses[1])
        window['error'].Update(response)
    elif event == 'video2':
        sg.popup('Checking if video is playing', auto_close=True, auto_close_duration=2)
        response = checkProcess(addresses[2])
        window['error'].Update(response)
    elif event == 'video3':
        sg.popup('Checking if video is playing', auto_close=True, auto_close_duration=2)
        response = checkProcess(addresses[3])
        window['error'].Update(response)
    elif event == 'video4':
        sg.popup('Checking if video is playing', auto_close=True, auto_close_duration=2)
        response = checkProcess(addresses[3])
        window['error'].Update(response)

    if event =='_update':
        sg.popup('Updating all videos', auto_close=True, auto_close_duration=2)
        for i in range(len(addresses)):
            print('Updating ' + addresses[i])
            updateVideos(addresses[i])
            print('finished updating ' + addresses[i])


    if event == 'Clear':
        window['error'].Update('')

window.close()
