#!/bin/sh

echo "### Calibrating touch panel... ###" 
sudo ts_calibrate
echo "- Done"
echo "### Installing script... ###"
cd /home/pi/
git clone https://github.com/CaptainStouf/WebSecurityEverywhere.git
sudo dpkg -i /home/pi/WebSecurityEverywhere/script/data/python-geoip_1.2.4-2_armhf.deb
echo "- Done"

echo "### Building new SSH keys... ###"
sudo rm /etc/ssh/ssh_host_* && sudo dpkg-reconfigure openssh-server
echo "- Done"

echo "### Preparing next boot... ###"
sudo echo "#!/bin/sh -e
sudo python /home/pi/WebSecurityEverywhere/script/unjailpi/start.py

_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

exit 0
" > /etc/rc.local
echo "- Done"

sudo reboot
