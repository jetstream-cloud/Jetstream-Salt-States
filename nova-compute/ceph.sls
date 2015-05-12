cephrepo:
  pkgrepo.managed:
    - humanname: Ceph Repo
    - baseurl: http://ceph.com/rpm-hammer/el7/x86_64/
    - gpgcheck: 1
    - gpgkey: https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc
    - require_in:
      - pkg: ceph

ceph:
  pkg.installed

/etc/ceph/ceph.conf:
  file.managed:
    - source: salt://ceph/ceph.conf


/etc/ceph/ceph.client.cinder.keyring:
  file.managed:
    - source: salt://ceph/ceph.client.cinder.keyring
