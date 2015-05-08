{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}


keystone:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - requirein:
      - mysql_user: keystonelocalhost
      - mysql_grants: keystonelocalhost
      - mysql_user: keystonewildcard
      - mysql_grans: keystonewildcard

keystonelocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: localhost
    - name: keystone
    - password: {{ pillar['keystone_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: "%"

keystonewildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: "%"
    - name: keystone
    - password: {{ pillar['keystone_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: keystone.*
    - user: keystone
    - host: localhost

keystone-manage pki_setup --keystone-user keystone --keystone-group keystone:
  cmd.run:
    - creates: /etc/keystone/ssl

/etc/keystone/ssl:
  file.directory:
    - user: keystone
    - group: keystone
    - mode: 660
    - recurse:
      - user
      - mode
      - group
/var/log/keystone:
  file.directory:
    - user: keystone
    - group: keystone
    - recurse:
      - user
      - group
include:
  - keystone.keystoneconf
openstack-keystone:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/keystone/keystone.conf
      - cmd: openstack-keystone 
  cmd.run:
    - name: su -s /bin/sh -c "keystone-manage db_sync" keystone
    - stateful: True
keystone-identity-service:
  cmd.run:
    - name: openstack service create --type identity   --description "OpenStack Identity" keystone
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q keystone
    - requires:
      - service: openstack-keystone
keystone-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl http://172.16.128.2:5000/v2.0 --internalurl http://172.16.128.2:5000/v2.0 --adminurl http://172.16.128.2:35357/v2.0 --region RegionOne identity
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q keystone
    - requires:
      - service: openstack-keystone
admin-project:
  cmd.run:
    - name: openstack project create --description "Admin Project" admin
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack project list | grep  -q admin
    - requires:
      - service: openstack-keystone
admin-user:
  cmd.run:
    - name: openstack user create --password {{pillar['admin_pass']}} admin
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q admin
    - requires:
      - cmd: openstack-keystone
admin-role:
  cmd.run:
    - name: openstack role create admin
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack role list | grep  -q admin
    - requires:
      - service: openstack-keystone
admin-role-project:
  cmd.run:
    - name: openstack role add --project admin --user admin admin
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list admin --project admin | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: admin-user
      - cmd: admin-project
service-project:
  cmd.run:
    - name: openstack project create --description "Service Project" service
    - env:
      - OS_URL: http://172.16.128.2:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack project list | grep  -q service
    - requires:
      - service: openstack-keystone
python-openstackclient: 
  pkg.installed
memcached: 
  pkg:
    - installed
  service:
    - enable: True
    - running
python-memcached:
  pkg.installed
