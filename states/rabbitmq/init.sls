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

