{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set os_family = salt['grains.get']('os_family', '') %}


cinder:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - requirein:
      - mysql_user: cinderlocalhost
      - mysql_grants: cinderlocalhost
      - mysql_user: cinderewildcard
      - mysql_grans: cinderwildcard
      
cinderlocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: localhost
    - name: cinder
    - password: {{ pillar['cinder_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: cinder.*
    - user: cinder
    - host: "%"

cinderwildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: "%"
    - name: cinder
    - password: {{ pillar['cinder_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: cinder.*
    - user: cinder
    - host: localhost
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

include:
  - cinder.cinderconf

openstack-cinder:
  pkg:
    - name: {{ pillar['openstack-cinder'] }}
    - installed
    - require_in:
      - cmd: openstack-cinder-api
      - ini: /etc/cinder/cinder.conf 
python-cinderclient:
  pkg.installed
python-oslo-db:
  pkg.installed

openstack-cinder-api:
  service:
    - name: {{ pillar['openstack-cinder-api'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/cinder/cinder.conf
    - require:
      - cmd: openstack-cinder-api
  cmd.run:
    - name: su -s /bin/sh -c "cinder-manage db sync" cinder
    - stateful: True
    - require:
      - mysql_database: cinder

openstack-cinder-scheduler:
  service:
    - name: {{ pillar['openstack-cinder-scheduler'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/cinder/cinder.conf
    - require:
      - cmd: openstack-cinder-api
      