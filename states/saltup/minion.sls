salt-minion:
  pkg:
    - installed
  service:
    - running
    - enable: True

/etc/salt/minion:
  ini.options_present:
    - separator: ':'
    - sections: 
          master: {{ pillar['salt-master-ip'] }} 
