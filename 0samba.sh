#docker arch
yay -S --noconfirm docker
sudo systemctl restart docker
sudo docker pull archlinux
#broken hard disk
#https://www.addictivetips.com/ubuntu-linux-tips/fix-a-bad-hard-drive-on-linux/
sudo fsck /dev/sdb -y
sudo dd if=/dev/zero of=/dev/sdb bs=1M
#https://unix.stackexchange.com/questions/30106/move-qcow2-image-to-physical-hard-drive
qcow2fp="/var/lib/libvirt/images/W10.qcow2"
sudo qemu-img dd -f qcow2 -O raw bs=4M if=$qcow2fp of=/dev/nvme0n1
sudo qemu-img convert "$qcow2fp" -O raw ~/disk.img
sudo qemu-img convert -f raw -O raw "/home/$USER/disk.img" /dev/sdb
sudo qemu-img convert -f qcow2 -O raw "$qcow2fp" /dev/sdb
#https://serverfault.com/questions/438083/how-to-decrease-the-size-of-a-kvm-virtual-machine-disk-image
qcow2fp="/var/lib/libvirt/images/W10.qcow2"
sudo qemu-img resize "$qcow2fp" 255G
sudo qemu-img resize "$qcow2fp" 256G
sudo qemu-img resize --shrink "$qcow2fp" 128G
#GamesDir
ln -s /mnt/SED/AY/Games/Games /home/user/Games
#GPUDir
sudo mkdir -p /sys/devices/pci0000:00/00:02.0/mdev_supported_types/i915-GVTg_V5_4
echo "a6129303-5a44-46ac-8e95-d0cce967f16a" | sudo tee "/sys/devices/pci0000:00/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_4/create"
echo 1 | sudo tee -a /sys/bus/pci/devices/0000:00:02.0/a6129303-5a44-46ac-8e95-d0cce967f16a/remove
sudo mkdir -p /sys/devices/pci0000:00/00:02.0/mdev_supported_types/i915-GVTg_V5_8
echo "6aeeaa8b-e7bf-4086-b284-4836dcb20dad" | sudo tee "/sys/devices/pci0000:00/0000:00:02.0/mdev_supported_types/i915-GVTg_V5_8/create"
echo 1 | sudo tee -a /sys/bus/pci/devices/0000:00:02.0/6aeeaa8b-e7bf-4086-b284-4836dcb20dad/remove
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /t REG_DWORD /f /v "PaintDesktopVersion" /d 0
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /t REG_SZ /f /v "Looking Glass" /d "C:\Users\user\Desktop\looking-glass-host.exe"
#https://www.youtube.com/watch?v=oRHSrnQueak&vl=en
printf "/dev/disk/by-id/ata-ST2000DM008-2FR102_ZFL0SCRF-part1 /mnt/SED ntfs uid=1000,gid=1000,rw,user,exec,umask=000 0 0" | sudo tee /etc/fstab
cp "/etc/samba/smb.conf" "/etc/samba/smb.conf.old"
printf "[global]
 server role = standalone server
 map to guest = bad user
 usershare allow guests = yes
 hosts allow = 192.168.0.0/16
 hosts deny = 0.0.0.0/0

[SED]
  comment = Open Linux Share
  path = /mnt/SED
  read only = no
  guest ok = yes
  force create mode = 0755
  force user = user
  force group = user

" | sudo tee "/etc/samba/smb.conf"

testparm
#ifconfig | grep virbr0
#Win+R ip address above
#https://unix.stackexchange.com/questions/360396/getting-samba-working-in-manjoro-linux-daemon-failed-to-start-samba-detected-m
systemctl disable samba
systemctl stop samba
systemctl enable smb
systemctl start smb
systemctl status smb
systemctl enable nmb
systemctl start nmb
systemctl status nmb


#https://stackoverflow.com/questions/36310293/how-to-copy-content-of-a-folder-to-another-specific-folder-using-powershell