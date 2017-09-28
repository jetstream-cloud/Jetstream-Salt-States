{% set os_family = salt['grains.get']('os_family', '') %}

centos-release-ceph-jewel-1.0-1.el7.centos.noarch:
  pkg.removed

ceph-release-1-1.el7.noarch:
  pkg.removed

https://download.ceph.com/rpm-luminous/el7/noarch/ceph-release-1-1.el7.noarch.rpm:
  pkg.installed

