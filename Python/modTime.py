import os.path
import time

fileLocation = r'C:\Users\aessinger\Desktop\wpaNetworkConfig.txt'


print('last modified: %s' % time.ctime(os.path.getmtime(fileLocation)))
