/etc/sysconfig/network-scripts/ifcfg-bond0.330:
  file.managed:
    - source: salt://bonded-ifcfg/ifcfg-bond0.330
