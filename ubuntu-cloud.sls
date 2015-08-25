ubuntu-cloud-keyring:
  pkg.installed

ubuntu-cloud-archive:
  pkgrepo.managed:
    - humanname: Ubuntu Cloud Archive
    - name: deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/kilo main
    - dist: trusty-updates/kilo
    - file: /etc/apt/sources.list.d/cloudarchive-kilo.list
    - require:
      - pkg: ubuntu-cloud-keyring