cinder-user:
  cmd.run:
    - name: openstack user create --password {{pillar['cinder_pass']}} cinder
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q cinder

cinder-role-project:
  cmd.run:
    - name: openstack role add --project service --user cinder admin
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list cinder --project service | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: cinder-user
      - cmd: service-project
cinder-service:
  cmd.run:
    - name: openstack service create --type volume --description "OpenStack Block Storage" cinder
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep -v volumev2 | grep  -q volume
    - requires:
      - service: openstack-keystone
cinderv2-service:
  cmd.run:
    - name: openstack service create --type volumev2 --description "OpenStack Block Storage" cinderv2
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q volumev2
    - requires:
      - service: openstack-keystone      
cinder-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl http://{{ pillar['cinderpublichost'] }}:8776/v2/%\(tenant_id\)s --internalurl http://{{ pillar['cinderprivatehost'] }}:8776/v2/%\(tenant_id\)s --adminurl http://{{ pillar['cinderprivatehost'] }}:8776/v2/%\(tenant_id\)s --region RegionOne volume
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep -v volumev2 |grep  -q volume
    - requires:
      - service: openstack-keystone
cinderv2-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl http://{{ pillar['cinderpublichost'] }}:8776/v2/%\(tenant_id\)s --internalurl http://{{ pillar['cinderprivatehost'] }}:8776/v2/%\(tenant_id\)s --adminurl http://{{ pillar['cinderprivatehost'] }}:8776/v2/%\(tenant_id\)s --region RegionOne volumev2
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q volumev2
    - requires:
      - service: openstack-keystone      

