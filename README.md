# traktor
Traktor will autamically install Tor, polipo, dnscrypt-proxy and Tor Browser Launcher in a Arch Linux based distros like Arch Linux, Manjaro,... and configures them as well.

To do this, just run 'traktor-arch.sh' file in a supported shell like bash and watch for prompts it asks you.

## Note
If you need anonymity or strong privacy, manually run torbrowser-launcher after installing traktor and use it.

## Install
    wget https://github.com/archusers/traktor-arch/archive/master.zip -O traktor.zip
    unzip traktor.zip && cd traktor-arch-master
    ./traktor-arch.sh

## Update
If you cannot connect to tor, you need to update your bridges on /etc/tor/torrc manually OR just run update-torrc.sh script like this:
    ./update-torrc.sh

## Remote install
type in bash:

    curl -s https://raw.githubusercontent.com/archusers/traktor-arch/master/traktor-arch.sh | sh