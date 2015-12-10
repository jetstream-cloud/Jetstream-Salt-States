nova-user:
  cmd.run:
    - name: openstack user create --password {{pillar['nova_pass']}} nova
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q nova

nova-role-project:
  cmd.run:
    - name: openstack role add --project service --user nova admin
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list nova --project service | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: nova-user
      - cmd: service-project
nova-service:
  cmd.run:
    - name: openstack service create --type compute --description "OpenStack Compute" nova
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q compute
    - requires:
      - service: openstack-keystone
nova-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl http://{{ pillar['novapublichost'] }}:8774/v2/%\(tenant_id\)s --internalurl http://{{ pillar['novaprivatehost'] }}:8774/v2/%\(tenant_id\)s --adminurl http://{{ pillar['novaprivatehost'] }}:8774/v2/%\(tenant_id\)s --region RegionOne compute
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q compute
    - requires:
      - service: openstack-keystone

