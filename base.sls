updates:
  pkg.uptodate:
    - refresh: True

salt-minion:
  pkg.installed:
    - install_recommends: False
  service.dead:
    - enable: False
    - require:
        - pkg: salt-minion

/etc/salt/minion.d/minion.conf:
  file.managed:
    - source: salt://files/minion.conf
    - require:
        - pkg: salt-minion

ssh:
  service.running:
    - enable: True

AAAAC3NzaC1lZDI1NTE5AAAAIPKOgbEQCKZtXBp+8wXIHzvkn5uG8utkwFwmbGp65yBb:
  ssh_auth.present:
    - user: william
    - enc: ed25519
    - comment: Brimborion

# Enable the Raspberry Pi 4 Case Fan.
/boot/config.txt:
  file.blockreplace:
    - marker_start: '#-- start managed zone --'
    - marker_end: '#-- end managed zone --'
    - content: |
        [all]
        dtoverlay=gpio-fan,gpiopin=14,temp=80000
    - append_if_not_found: true
    - backup: false

# Disable automatic user login.
/etc/lightdm/lightdm.conf:
  file.replace:
    - pattern: ^#*autologin-user=.*
    - repl: '#autologin-user='
/etc/systemd/system/getty@tty1.service.d/autologin.conf:
  file.absent: []

/etc/timezone:
  file.managed:
    - contents: UTC
