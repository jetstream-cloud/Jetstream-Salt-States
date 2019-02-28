ceph-repo-rpm:
  cmd.run: 
    - name: yum install -y https://download.ceph.com/rpm-mimic/el7/noarch/ceph-release-1-1.el7.noarch.rpm
    - unless: rpm -q ceph-release-1-1.el7.noarch

ceph-packages:
  pkg.installed: 
    - pkgs: 
      - python-cephfs
      - ceph-selinux
      - ceph-base
      - libcephfs2
      - ceph-common
    - require:
      - ceph-repo-rpm

/etc/ceph:
  file.recurse:
    - source: salt://ceph/ceph-config
    - include_empty: True



