#!/bin/bash
clear

echo -e "Traktor v1.3\nTor will be automatically installed and configured…\n\n"

# Install Packages
sudo pacman -Sy 1>/dev/null 2>&1
#yaourt -S  tor-browser-en-ir
sudo pacman -S	tor obfsproxy polipo dnscrypt-proxy  

#configuring dnscrypt-proxy
sudo wget https://AmirrezaFiroozi.github.io/traktor/dnscrypt-proxy.service -O /usr/lib/systemd/system/dnscrypt-proxy.service > /dev/null
sudo systemctl daemon-reload
sudo echo "nameserver 127.0.0.1" >/etc/resolv.conf
sudo chattr +i /etc/resolv.conf
sudo systemctl enable dnscrypt-proxy.service
sudo systemctl start dnscrypt-proxy
# Write Bridge
sudo wget https://AmirrezaFiroozi.github.io/traktor/torrcV3 -O /etc/tor/torrc > /dev/null

# Make tor log directory 
sudo systemctl start tor 1>/dev/null 2>&1
sudo systemctl stop Tor 1>/dev/null 2>&1
sudo mkdir /var/log/tor/
sudo chown tor:tor /var/log/tor/
sudo chmod g+w /var/log/tor/
# Fix Apparmor problem
#sudo sed -i '27s/PUx/ix/' /etc/apparmor.d/abstractions/tor
#sudo apparmor_parser -r -v /etc/apparmor.d/system_tor

# Write Polipo config
echo 'logSyslog = true
logFile = /var/log/polipo/polipo.log
proxyAddress = "::0"        # both IPv4 and IPv6
allowedClients = 127.0.0.1
socksParentProxy = "localhost:9050"
socksProxyType = socks5' | sudo tee /etc/polipo/config > /dev/null
sudo systemctl restart polipo

echo "Do you want to use tor on whole network? [y/N]"
echo "If press No you have to manually set proxy to SOCKS5 127.0.0.1:9050 or HTTP 127.0.0.1:8123"

read -n 1 SELECT
if [ "$SELECT" = "Y" -o "$SELECT" = "y" ]
then
	# Set IP and Port on HTTP and SOCKS
	gsettings set org.gnome.system.proxy mode 'manual'
	gsettings set org.gnome.system.proxy.http host 127.0.0.1
	gsettings set org.gnome.system.proxy.http port 8123
	gsettings set org.gnome.system.proxy.socks host 127.0.0.1
	gsettings set org.gnome.system.proxy.socks port 9050
	gsettings set org.gnome.system.proxy ignore-hosts "['localhost', '127.0.0.0/8', '::1', '192.168.0.0/16', '10.0.0.0/8', '172.16.0.0/12']"
fi
# Install Finish
echo "Install Finished successfully…"
sudo systemctl start tor 1>/dev/null 2>&1
sudo systemctl enable tor 1>/dev/null 2>&1
# Wait for tor to establish connection
echo "Tor is trying to establish a connection. This may take long for some minutes. Please wait" | sudo tee /var/log/tor/log
bootstraped='n'
sudo systemctl restart tor
while [ $bootstraped == 'n' ]; do
	if sudo cat /var/log/tor/log | grep "Bootstrapped 100%: Done"; then
		bootstraped='y'
	else
		sleep 1
	fi
done
echo -e "\nDo you want to install tor-browser too? [y/N]"

read -n 1 SELECT
if [ "$SELECT" = "Y" -o "$SELECT" = "y" ]
then
yaourt -S tor-browser-en-ir
fi
echo "Congratulations!!! Your computer is using Tor. may run tor-browser-en-ir now."
