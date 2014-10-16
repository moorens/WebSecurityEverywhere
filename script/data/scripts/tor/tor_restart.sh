#!/bin/sh

# destinations you don't want routed through Tor
NON_TOR="192.168.1.0/24 192.168.200.0/24"

# the UID Tor runs as
TOR_UID="108"

# Tor's TransPort
TRANS_PORT="9040"

# your internal interface
INT_IF="wlan0"
#your interface you hook a switch to so you can connect computers into your proxy
EXT_IF="wlan1"

sudo service tor restart

sudo iptables -F
sudo iptables -t nat -F

sudo iptables -t nat -A OUTPUT -o lo -j RETURN
sudo iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN
sudo iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53
for NET in $NON_TOR; do
 sudo iptables -t nat -A OUTPUT -d $NET -j RETURN
 sudo iptables -t nat -A PREROUTING -i $INT_IF -d $NET -j RETURN
done

sudo iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TRANS_PORT

sudo iptables -t nat -A PREROUTING -i $EXT_IF -p udp --dport 53 -j REDIRECT --to-ports 53
sudo iptables -t nat -A PREROUTING -i $EXT_IF -p tcp --syn -j REDIRECT --to-ports $TRANS_PORT

sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
for NET in $NON_TOR 127.0.0.0/8; do
 sudo iptables -A OUTPUT -d $NET -j ACCEPT
done
sudo iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
sudo iptables -A OUTPUT -j REJECT

sudo iptables -t nat -A PREROUTING -i $EXT_IF -p udp --dport 22 -j REDIRECT --to-ports 22
