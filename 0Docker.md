
# dockerarchcuda

### Linux
```
sudo apt-get update
sudo apt-get install -y git
# sudo pacman -S --noconfirm yay pamac
# yay -S --noconfirm git
sudo rm -rf ~/dockerarchcuda
cd ~
git clone https://github.com/pagkly/dockerarchcuda
cd ./dockerarchcuda
sudo docker build -t dockerarchcuda .
```

### Windows 10
cd $env:USERPROFILE
rmdir /S /Q dockerarchcuda
git clone https://github.com/pagkly/dockerarchcuda
cd dockerarchcuda
docker build -t dockerarchcuda .