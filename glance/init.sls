{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set os_family = salt['grains.get']('os_family', '') %}


glance:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - requirein:
      - mysql_user: glancelocalhost
      - mysql_grants: glancelocalhost
      - mysql_user: glanceewildcard
      - mysql_grans: glancewildcard
      
glancelocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: localhost
    - name: glance
    - password: {{ pillar['glance_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: "%"

glancewildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: "%"
    - name: glance
    - password: {{ pillar['glance_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: localhost
glance-user:
  cmd.run:
    - name: openstack user create --password {{pillar['glance_pass']}} glance
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q glance

glance-role-project:
  cmd.run:
    - name: openstack role add --project service --user glance admin
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list glance --project service | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: glance-user
      - cmd: service-project
glance-service:
  cmd.run:
    - name: openstack service create --type image --description "OpenStack Image service" glance
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q glance
    - requires:
      - service: openstack-keystone
glance-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl http://{{ pillar['glancepublichost'] }}:9292 --internalurl http://{{ pillar['glanceprivatehost'] }}:9292 --adminurl http://{{ pillar['glanceprivatehost'] }}:9292 --region RegionOne image
    - env:
      - OS_URL: http://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q glance
    - requires:
      - service: openstack-keystone
      
      
include:
  - glance.glance-apiconf
  - glance.glance-registryconf
  
openstack-glance:
  pkg:
    - name: {{ pillar['openstack-glance'] }}
    - installed
{% if os_family == 'RedHat' %}
python-glance:
  pkg.installed
{% endif %}
python-glanceclient:
  pkg.installed


openstack-glance-api:
  service:
    - name: {{ pillar['openstack-glance-api'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/glance/glance-api.conf
    - require:
      - cmd: openstack-glance-api
  cmd.run:
    - name: su -s /bin/sh -c "glance-manage db_sync" glance
    - stateful: True
    - require:
      - pkg: openstack-glance
      - mysql_user: glancelocalhost
      

openstack-glance-registry:
  service:
    - name: {{ pillar['openstack-glance-registry'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/glance/glance-api.conf
    - require:
      - cmd: openstack-glance-api
