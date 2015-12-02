openstack-liberty-repo:
  pkgrepo.managed:
    - humanname: Temporary OpenStack Kilo new deps
    - baseurl: http://mirror.centos.org/centos/7/cloud/x86_64/openstack-liberty/ 
    - gpgcheck: 0
    - enabled: 1 

openstack-selinux:
  pkg.installed
    - require:
      - pkgrepo: openstack-liberty-repo
