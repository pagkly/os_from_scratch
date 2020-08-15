
#Drive
#https://askubuntu.com/questions/59064/how-to-run-a-checkdisk
#https://www.linode.com/docs/quick-answers/linux/how-to-use-fsck-to-fix-disk-problems/
#https://superuser.com/questions/919844/is-there-any-option-to-quickly-scan-an-entire-hard-drive-for-bad-blocks
CHKDSK [volume] /r
fsck -AR -y
badblocks -nsv /dev/[volume]
ntfs-3g

#https://wiki.manjaro.org/index.php?title=Manjaro-tools
#https://wiki.manjaro.org/Build_Manjaro_ISOs_with_buildiso
#https://wiki.manjaro.org/index.php?title=Buildiso_with_AUR_packages:_Using_buildpkg
yay -S manjaro-tools-base
yay -S manjaro-tools-pkg
yay -S manjaro-tools-iso

mkdir -p ~/online-repo/x86_64
mkdir -p ~/pkgbuild
#https://forum.manjaro.org/t/buildpkg-and-buildpkg-c-are-not-working/16471/5
#https://forum.manjaro.org/t/solved-unable-to-buld-aur-package-with-buildpkg/35897/2
aurname="yay"
cd ~/pkgbuild
git clone https://aur.archlinux.org/$aurname
ls $aurname/PKGBUILD
#cd $aurname
#makepkg -sr #in
#out
buildpkg -p $aurname -c

#https://forum.manjaro.org/t/pamac-still-builds-packages-as-pkg-tar-xz-instead-of-zstd/120481
#sudo nano /etc/makepkg.conf
#PKGEXT
ls /var/cache/manjaro-tools/pkg/stable/x86_64
cp -r /var/cache/manjaro-tools/pkg/stable/* ~/online-repo
cd ~/online-repo/x86_64
repo-add online-repo.db.tar.gz *.pkg.tar.*
ls
#w
cd ..

#offlineWORKS
#https://www.linuxsecrets.com/manjaro-wiki/index.php%3Ftitle=Buildiso_with_AUR_packages:_Using_yaourt.html
#https://forum.manjaro.org/t/buildiso-error-and-need-online-repo-for-aur-packages/57025/19
#https://forum.manjaro.org/t/buildiso-error-and-need-online-repo-for-aur-packages/57025/22
#https://forum.manjaro.org/t/building-custom-iso-with-aur/66480?u=lolix
#https://forum.manjaro.org/t/building-custom-iso-with-aur/66480?u=lolix
#https://www.youtube.com/watch?v=2JEiP1OYe8E

#x64
echo "
[online-repo]
SigLevel = Never
Server = file:///home/user/online-repo/" | sudo tee -a /usr/share/manjaro-tools/pacman-multilib.conf

#x86
echo "
[online-repo]
SigLevel = Never
Server = file:///home/user/online-repo/" | sudo tee -a /usr/share/manjaro-tools/pacman-default.conf

#ONLINENOTOWRKING
sudo nano ~/iso-profiles/manjaro/xfce/user-repos.conf
[online-repo]
SigLevel = Never
Server = https://sourceforge.net/projects/mymanjarop/files/x86_64
Server = https://sourceforge.net/p/mymanjaropkg/code/ci/master/tree/x86_64
Server = file:///home/user/online-repo/x86_64
Server = https://gitlab.com/pagkly/mymanjaropkg/-/tree/master/x86_64
Server = https://github.com/pagkly/mymanjaropkg/tree/master/x86_64


sudo mkdir -p /usr/share/manjaro-tools/iso-profiles/official/xfce
sudo nano /usr/share/manjaro-tools/iso-profiles/official/xfce/Packages-Xfce

## XFCE Main Packages
ffmpegthumbnailer
gconf # fix qt-theme
gnome-keyring # fix wlan segfault
gufw # firewall
accountsservice
lightdm-gtk-greeter
lightdm-gtk-greeter-settings
light-locker
manjaro-settings-manager
menulibre


echo "
## AUR packages
yay " |sudo tee -a /home/$USER/iso-profiles/manjaro/xfce/PACKAGE-DESKTOP

buildiso -p xfce
ls /var/cache/manjaro-tools/iso/
sudo nautilus /var/cache/manjaro-tools/iso/

#vio
#https://www.reddit.com/r/VFIO/comments/9nu0au/cant_install_latest_viostor_driver/