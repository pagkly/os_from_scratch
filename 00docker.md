# Docker commands
docker ps -a
###delete everything
docker images -a -q | % { docker image rm $_ -f }
docker system prune -a --volumes 

# Docker Archlinux CUDA Gnome

Installed Versions:
* NVIDIA Driver (manual install)
* CUDA 

**IMPORTANT**: Host driver version must match exactly
## Install
#### Linux
```
sudo apt-get update
sudo apt-get install -y git
# sudo pacman -S --noconfirm yay pamac
# yay -S --noconfirm git
sudo rm -rf ~/dockerarchcuda
cd ~
git clone https://github.com/pagkly/dockerarchcuda
cd ~
cd ./dockerarchcuda
sudo docker build -t dockerarchcuda .
```
#### Windows 10
```
cd $env:USERPROFILE
rmdir /S /Q dockerarchcuda
git clone https://github.com/pagkly/dockerarchcuda
cd ~
cd dockerarchcuda
docker build -t dockerarchcuda .
```

## Run
RUN container as root with vnc @ 1024x768:
```
docker run -it --user 0 --restart=always -d -p 5900 --privileged --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH --security-opt seccomp=unconfined dockerarchcuda x11vnc -forever -create -scale 1024x768
```

## Run VNC
```
choco install -y vncviewer
vncviewer :port
```



# dockerubuntuvnc
Docker container with :
- xfce4
- x11vnc
- thunar
- bless
- ...some other tools

BUILD container :
#### Linux
```
sudo apt-get update
sudo apt-get install -y git
# sudo pacman -S --noconfirm yay pamac
# yay -S --noconfirm git
sudo rm -rf ~/dockerubuntuvnc
cd ~
git clone https://github.com/pagkly/dockerubuntuvnc
cd ~
cd ./dockerubuntuvnc
sudo docker build -t dockerubuntuvnc .
```

#### Windows 10
```
cd $env:USERPROFILE
rmdir /S /Q dockerubuntuvnc
git clone https://github.com/pagkly/dockerubuntuvnc
cd ~
cd dockerubuntuvnc
docker build -t dockerubuntuvnc .
```

RUN container as root with vnc @ 1024x768:
```
docker run -it --user 0 --restart=always -d -p 5910 --privileged --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH --security-opt seccomp=unconfined dockerubuntuvnc sudo su -c "x11vnc -forever -create -scale 1024x768"
```

RUN vnc :
```
choco install -y vncviewer
vncviewer :5900
```

docker pull nvidia/cuda
docker run -it --user 0 --restart=always --privileged --cap-add SYS_ADMIN --cap-add DAC_READ_SEARCH --security-opt seccomp=unconfined nvidia/cuda
docker exec -it /bin/bash