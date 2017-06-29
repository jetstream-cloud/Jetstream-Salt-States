salt-minion:
  pkg:
    - installed
  service:
    - running
    - enable: True

/etc/salt/minion:
  ini.options_present:
    master: {{ salt_master_ip }}
