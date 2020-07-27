# Enter script code
#https://www.maketecheasier.com/ubuntu-empty-trash-automatically/
import subprocess
import os
#subprocess.call("pip3 install autotrash")
#subprocess.call("autotrash -d 1",shell=True)
#subprocess.call("rm -rf /home/$USER/.local/share/Trash/files/*",shell=True)
#https://vitux.com/four-ways-to-empty-the-trash-recycle-bin-in-ubuntu/
#subprocess.call("sudo apt-get install -y trash-cli",shell=True)
subprocess.call("trash-empty")