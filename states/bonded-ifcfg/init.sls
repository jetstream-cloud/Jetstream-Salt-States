/etc/sysconfig/network-scripts/ifcfg-bond0:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-bond0

/etc/sysconfig/network-scripts/ifcfg-em1:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-em1

/etc/sysconfig/network-scripts/ifcfg-em2:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-em2
