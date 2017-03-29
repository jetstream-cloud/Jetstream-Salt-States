/etc/sysconfig/network-scripts/ifcfg-bond0.360:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-bond0.360
