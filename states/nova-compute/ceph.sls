{% set os_family = salt['grains.get']('os_family', '') %}
cephrepo:
  pkgrepo.managed:
    - humanname: Ceph Repo
{% if os_family == 'RedHat' %}
    - baseurl: http://ceph.com/rpm-hammer/el7/x86_64/
    - gpgcheck: 1
{% elif os_family == 'Debian' %}
    - name: deb http://ceph.com/debian-hammer/ trusty main
    - file: /etc/apt/sources.list.d/ceph.list
{% endif %}
    - key_url: https://git.ceph.com/release.asc 
    - require_in:
      - pkg: ceph

ceph:
  pkg:
    - installed
    - require:
      - pkgrepo: cephrepo
  

/etc/ceph/ceph.conf:
  file.managed:
    - source: salt://ceph/ceph.conf
    - require:
      - pkg: ceph


/etc/ceph/ceph.client.cinder.keyring:
  file.managed:
    - source: salt://ceph/ceph.client.cinder.keyring
    - require:
      - pkg: ceph
