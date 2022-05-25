Salt states for managing my Raspberry Pi.

Bootstrapping:

* Set `flightradar24_sharing_key` in /srv/pillar.
* `# apt --no-install-recommends install python3-pygit2 salt-minion`
* `# curl -o /etc/salt/minion.d/minion.conf https://raw.githubusercontent.com/williterate/raspberrypi-states/main/files/minion.conf`
* `# salt-call --local state.apply`
