import os
import os.path
import shutil
import time

src="/home/pi/shared" # the source directory to check for files ie the network drive
dest="/home/pi/video" # the folder where the files will get moved to and where the video looper looks in

# list from both source and destination folder
src_files = os.listdir(src)
dest_files = os.listdir(dest)

currFile = ''
newFile = ''

# loop through src folder and get the name and path
# of each file
for file_name_src in src_files:
    # join the name and path of file
    full_src_name = os.path.join(src, file_name_src)
    full_dest_name = os.path.join(dest, file_name_src)
    # get the modified date of file in shared drive
    newFile = time.ctime(os.path.getmtime(full_src_name))
    # get the modified date of file in local folder
    try:
        currFile = time.ctime(os.path.getmtime(full_dest_name))
    except:
        currFile = 'null'
    #check if file isn't in video dir and not a folder
    if file_name_src not in dest_files and os.path.isfile(full_src_name):
            #copy file to video directory
            print("copying " + file_name_src)
            shutil.copy(full_src_name, dest)
    elif newFile < currFile and currFile != 'null':
        print('newer version available')
        print('copying ' + file_name_src)
        shutil.copy(full_src_name, dest)
    else:
        print('shared version the same nothing to do')
        
# loop through movies in videos folder
# and compare to see if any need removed
for file_name_dest in dest_files:
    full_name = os.path.join(dest, file_name_dest)
    if file_name_dest not in src_files:
        print("removing " + file_name_dest)
        os.remove(full_name)