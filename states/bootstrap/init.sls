bootstrap_packages:
  pkg.installed: 
    - pkgs: 
      - epel-release
      - vim-enhanced 
      - nmap-ncat
      - centos-release-openstack-ocata
      - rsync
      - bind-utils
      - sysstat
      - iotop
      - tmux
      - iputils
      - net-tools
      - procps-ng
      - tcpdump
      - vim-enhanced
      - curl
      - wget

openstack_packages:
  pkg.installed: 
    - pkgs: 
      - openstack-utils
      - python-openstackclient

America/Chicago:
  timezone.system

disabled:
  selinux.mode

/root/configcheck:
  file.managed:
    - source: salt://bootstrap/configcheck
    - user: root
    - group: root
    - mode: 755
