#!/bin/sh

echo "### Installing necessary packages... ###"
sudo apt-get install -y geoip-database libgeoip1 python-pygame python-psutil python-setuptools python-simplejson python-requests python-rpi.gpio python-pip git hostapd iptables dnsmasq tor openvpn unzip
sudo pip install evdev
echo "- Done"
echo "### Patching hostapd for RTL8192C... ###"
cd /tmp
sudo wget http://fichiers.touslesdrivers.com/39144/RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip
sudo unzip RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911.zip
cd RTL8188C_8192C_USB_linux_v4.0.2_9000.20130911
cd wpa_supplicant_hostapd
sudo tar -xvf wpa_supplicant_hostapd-0.8_rtw_r7475.20130812.tar.gz
cd wpa_supplicant_hostapd-0.8_rtw_r7475.20130812
cd hostapd
sudo make
sudo make install
sudo mv hostapd /usr/sbin/hostapd
sudo chown root.root /usr/sbin/hostapd
sudo chmod 755 /usr/sbin/hostapd
echo "- Done"
echo "### Writing config files... ###"
sudo echo "ctrl_interface=/var/run/hostapd
driver=rtl871xdrv
ieee80211n=1
ctrl_interface_group=0
beacon_int=100
interface=wlan0
ssid=MON_SSID
hw_mode=g
channel=6
auth_algs=1
wmm_enabled=1
eap_reauth_period=360000000
macaddr_acl=0c
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=MON_PASSWORD
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP" > /etc/hostapd/hostapd.conf

sudo echo "interface=wlan0
dhcp-range=192.168.200.100,192.168.200.200,255.255.255.0,12h" > /etc/dnsmasq.conf

sudo echo "auto lo
iface lo inet loopback

# eth0 : client DHCP
iface eth0 inet dhcp

# usb0
allow-hotplug usb0
auto usb0 
iface usb0 inet dhcp

# wlan0 : AP
allow-hotplug wlan0
iface wlan0 inet static
        address 192.168.200.1
        netmask 255.255.255.0
        network 192.168.200.0
        broadcast 192.168.200.255

# wlan1 : client
allow-hotplug wlan1

iface wlan1 inet manual
        wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
        
iface default inet dhcp

up iptables-restore < /etc/iptables.ipv4.nat" > /etc/network/interfaces

echo "quiet dwc_otg.lpm_enable=0 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait fbtft_device.name=hy28a fbtft_device.rotate=90 fbtft_device.speed=48000000 fbtft_device.fps=50 fbtft_device.debug=0 fbtft_device.verbose=0 fbcon=map:10 fbcon=font:ProFont6x11 logo.nologo consoleblank=0 bcm2708.w1_gpio_pin=18" > /boot/cmdline.txt

echo "# blacklist spi and i2c by default (many users don't need them)

#blacklist spi-bcm2708
#blacklist i2c-bcm2708" > etc/modprobe.d/raspi-blacklist.conf
echo "- Done"

echo "### Preparing next boot... ###"
sudo echo "#!/bin/sh -e
sudo sh /home/pi/WebSecurityEverywhere/script/data/scripts/install.sh

_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

exit 0
" > /etc/rc.local
echo "- Done"

sudo reboot
