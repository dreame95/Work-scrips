#!/bin/bash

# sneaky way to check for internet connection
while ! ping -c 1 -W 1 www.google.com; do
    echo "not connected yet"
    sleep 1
done
echo "Internet is connected"
#mount the drive
# the section after || is a fallback if the mount command fails
# it will let you know mount failed instead of no output
mount -t cifs //wmh-dfs2/data/WMHVision /home/pi/shared -o user=rasp-pi,password=needsChangedToActualPassword,vers=3.0 || echo "mount failed"