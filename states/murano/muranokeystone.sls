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
    - name: openstack service create --type volume --description "OpenStack Block Storage" murano
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep -v volumev2 | grep  -q volume
    - requires:
      - service: openstack-keystone
murano-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['muranopublichost'] }}:8776/v2/%\(tenant_id\)s --internalurl https://{{ pillar['muranoprivatehost'] }}:8776/v2/%\(tenant_id\)s --adminurl https://{{ pillar['muranoprivatehost'] }}:8776/v2/%\(tenant_id\)s --region RegionOne volume
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep -v volumev2 |grep  -q volume
    - requires:
      - service: openstack-keystone

