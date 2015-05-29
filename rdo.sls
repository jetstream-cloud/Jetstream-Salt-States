openstack-kilo:
  pkgrepo.managed:
    - humanname: Temporary OpenStack Kilo new deps
    - baseurl: http://repos.fedorapeople.org/repos/openstack/openstack-kilo/el7/
    - gpgcheck: 0
    - enabled: 1 

openstack-kilo-testing:
  pkgrepo.managed:
    - humanname: Temporary OpenStack Kilo new deps
    - baseurl: http://repos.fedorapeople.org/repos/openstack/openstack-kilo/testing/el7/
    - gpgcheck: 0
    - enabled: 1

openstack-selinux:
  pkg.installed
