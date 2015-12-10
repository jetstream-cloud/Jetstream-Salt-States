{% set os_family = salt['grains.get']('os_family', '') %}

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



openstack-nova-api:
  pkg:
    - name: {{ pillar['openstack-nova-api'] }}
    - installed
    - require_in:
      - cmd: openstack-nova-api
      - ini: /etc/nova/nova.conf
  service:
    - name: {{ pillar['openstack-nova-api'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
      - ini: /etc/neutron/neutron.conf
    - require:
      - cmd: openstack-nova-api
  cmd.run:
    - name: su -s /bin/sh -c "nova-manage db sync" nova
    - stateful: True
openstack-nova-cert:
  pkg:
    - name: {{ pillar['openstack-nova-cert'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-cert'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-cert
      - service: openstack-nova-api
openstack-nova-conductor:
  pkg:
    - name: {{ pillar['openstack-nova-conductor'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-conductor'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-conductor
      - service: openstack-nova-api
openstack-nova-console:
  pkg:
    - name: {{ pillar['openstack-nova-console'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-console-service'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-console
      - service: openstack-nova-api
openstack-nova-novncproxy:
  pkg:
    - name: {{ pillar['openstack-nova-novncproxy'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-novncproxy'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-novncproxy
      - service: openstack-nova-api
openstack-nova-scheduler:
  pkg:
    - name: {{ pillar['openstack-nova-scheduler'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-scheduler'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-scheduler
      - service: openstack-nova-api
python-novaclient:
  pkg.installed

include:
  - nova.novaconf
