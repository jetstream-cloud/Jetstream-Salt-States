epel-release:
  pkg:
    - installed

prereq-packages:
  pkg.installed:
    - pkgs:
      - centos-release-openstack-queens: latest
      - bind-utils: latest
      - sysstat: latest
      - iotop: latest
      - tmux: latest
      - iputils : latest
      - net-tools: latest
      - nmap-ncat: latest
      - procps-ng: latest
      - tcpdump: latest
      - vim-enhanced: latest
      - curl: latest
      - wget: latest
