rabbitmq-server:
  pkg:
    - installed
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

/etc/default/rabbitmq-server:
  file.managed:
    - source: salt://rabbitmq/rabbitmq-etc-default
