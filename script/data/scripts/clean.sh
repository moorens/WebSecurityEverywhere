#!/bin/sh
echo "### Updating... ###"
sudo apt-get -y update
echo "- Done"
echo "### Removing packages... ###"
sudo rm -rf /home/pi/python_games sudo apt-get -y --force-yes remove x11-common midori lxde python3 python3-minimal lighttpd penguinspuzzle raspberrypi-artwork unzip wireless-tools ca-certificates libraspberrypi-doc xkb-data fonts-freefont-ttf lxde-common lxde-icon-theme omxplayer smbclient `sudo dpkg --get-selections | grep "\-dev" | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep python | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep x11 | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep sound | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep wolfram | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep advancemame | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep apache2 | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep libapache | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep libcwidget | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep cups | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep libdbd-mysql | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep libgdm | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep libcups | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep gnome | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep heirloom | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep java | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep lua | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep menu | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep mysql | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep php | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep vim | sed s/install//` `sudo dpkg --get-selections | grep -v "deinstall" | grep samba | sed s/install//`
echo "- Done"
sudo rm -rf opt
echo "### Upgrading... ###"
sudo apt-get -y upgrade
echo "- Done"
echo "### Cleaning... ###"
sudo apt-get -y autoremove
sudo apt-get clean
sudo apt-get autoclean
sudo apt-get purge
echo "- Done"
echo "### Removing swap ###"
sudo swapoff -a
cd /var
sudo dd if=/dev/zero of=swap bs=1M count=100 cd /var/log/
echo "- Done"

sudo sh /home/pi/WebSecurityEverywhere/script/data/scripts/prepare.sh &


