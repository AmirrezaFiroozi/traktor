#!/bin/bash
sudo wget https://amirrezafiroozi.github.io/traktor/torrcV3 -O /etc/tor/torrc > /dev/null

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

echo -e "\nCongratulations!!! Your computer is using Tor."
