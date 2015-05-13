{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}


nova:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - requirein:
      - mysql_user: novalocalhost
      - mysql_grants: novalocalhost
      - mysql_user: novaewildcard
      - mysql_grans: novawildcard
      
novalocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: localhost
    - name: nova
    - password: {{ pillar['nova_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: nova.*
    - user: nova
    - host: "%"

novawildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: "%"
    - name: nova
    - password: {{ pillar['nova_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: nova.*
    - user: nova
    - host: localhost
nova-user:
  cmd.run:
    - name: openstack user create --password {{pillar['nova_pass']}} nova
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q nova

nova-role-project:
  cmd.run:
    - name: openstack role add --project service --user nova admin
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
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
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q compute
    - requires:
      - service: openstack-keystone
nova-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl http://172.16.128.2:8774/v2/%\(tenant_id\)s --internalurl http://172.16.128.2:8774/v2/%\(tenant_id\)s --adminurl http://172.16.128.2:8774/v2/%\(tenant_id\)s --region RegionOne compute
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q compute
    - requires:
      - service: openstack-keystone



openstack-nova-api:
  pkg:
    - installed
  service:
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
    - installed
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
openstack-nova-conductor:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
openstack-nova-console:
  pkg:
    - installed
  service:
    - name: openstack-nova-consoleauth
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
openstack-nova-novncproxy:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
openstack-nova-scheduler:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
python-novaclient:
  pkg.installed

include:
  - nova.novaconf
