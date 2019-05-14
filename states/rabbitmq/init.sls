rabbitmq:
  pkgrepo.managed:
    - humanname: bintray-rabbitmq-server
    - baseurl: https://dl.bintray.com/rabbitmq/rpm/rabbitmq-server/v3.6.x/el/7/
    - gpgcheck: 1
    - gpgkey: https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc

net.ipv4.tcp_keepalive_time:
  sysctl.present:
    - value: 6
net.ipv4.tcp_keepalive_probes:
  sysctl.present:
    - value: 3
net.ipv4.tcp_keepalive_intvl:
  sysctl.present:
    - value: 3
net.ipv4.tcp_fin_timeout:
  sysctl.present:
    - value: 5
net.core.somaxconn:
  sysctl.present:
    - value: 4096

/etc/rabbitmq/rabbitmq.config:
  file.managed:
    - source: salt://rabbitmq/rabbitmq.config

/etc/default/rabbitmq-server:
  file.managed:
    - source: salt://rabbitmq/rabbitmq-etc-default

/var/lib/rabbitmq/.erlang.cookie:
  file.managed:
    - contents: {{ pillar['erlang_cookie'] }}

rabbitmq-server:
  pkg:
    - installed
    - version: 3.6.16
  service:
    - enable: True
    - running
    - require:
      - pkg: rabbitmq-server

rabbit_openstack_user:
  rabbitmq_user.present:
    - name: openstack
    - password: {{ pillar['openstack_rabbit_pass'] }}
    - perms:
      - '/':
        - '.*'
        - '.*'
        - '.*'


