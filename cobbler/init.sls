cobbler:
  pkg:
    - installed

cobbler-web:
  pkg:
    - installed

debmirror:
  pkg:
    - installed

isc-dhcp-server:
  pkg:
    - installed

/etc/cobbler/settings:
  file.managed:
    - source: salt://cobbler/settings
/etc/cobbler/dhcp.template
  file.managed:
    - souce: salt://cobbler/dhcp.template
    
cobblerrepo:
  pkgrepo.managed:
    - humanname: Cobbler 2.6 repo
    - name: "deb http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/xUbuntu_14.04/"
    - dist: "./"
    - file: /etc/apt/sources.list.d/cobbler.list
    - key_url: http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler26/xUbuntu_14.04/Release.key

