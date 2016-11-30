murano-user:
  cmd.run:
    - name: openstack user create --password {{pillar['murano_pass']}} murano
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q murano

murano-role-project:
  cmd.run:
    - name: openstack role add --project service --user murano admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list murano --project service | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: murano-user
      - cmd: service-project
murano-service:
  cmd.run:
    - name: openstack service create --type volume --description "Application Catalog for OpenStack" murano
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep -v volumev2 | grep  -q volume
    - requires:
      - service: openstack-keystone
murano-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['muranopublichost'] }}:8082 --internalurl https://{{ pillar['muranoprivatehost'] }}:8082 --adminurl https://{{ pillar['muranoprivatehost'] }}:8082 --region RegionOne murano
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list  |grep  -q murano
    - requires:
      - service: openstack-keystone

