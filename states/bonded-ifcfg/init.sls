/etc/sysconfig/network-scripts/ifcfg-bond0:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-bond0
    - template: jinja
    - context:
      ipaddr: {{ salt['grains.get']('ip4_interfaces:bond0:0') }} 

/etc/sysconfig/network-scripts/ifcfg-em1:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-em1

/etc/sysconfig/network-scripts/ifcfg-em2:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-em2

/etc/sysconfig/network:
  file.managed:
    - source: salt://bonded-ifcfg/etc-sysconfig-network
    - template: jinja
    - context:
      hostname: {{ salt['grains.get']('localhost') }}
