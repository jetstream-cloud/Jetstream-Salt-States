glance-user:
  cmd.run:
    - name: openstack user create --password {{pillar['glance_pass']}} glance
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q glance

glance-role-project:
  cmd.run:
    - name: openstack role add --project service --user glance admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list glance --project service | grep  -q admin
    - requires:
      - cmd: glance-user

glance-service:
  cmd.run:
    - name: openstack service create --type image --description "OpenStack Image service" glance
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q glance

glance-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['glancepublichost'] }}:9292 --internalurl https://{{ pillar['glanceprivatehost'] }}:9292 --adminurl https://{{ pillar['glanceprivatehost'] }}:9292 --region RegionOne image
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q glance

