
keystone_packages:
  pkg.installed: 
    - pkgs: 
      - python2-keystoneclient
      - httpd
      - mod_wsgi
      - memcached
      - python-memcached
      - {{ pillar['openstack-keystone'] }}
      - {{ pillar['python-memcached'] }}

cleanup_keystoneconf:
  cmd.run:
    - require:
      - keystone_packages
    - name: |
        sed -i '/^#/d' /etc/keystone/keystone.conf
        sed -i '/^$/d' /etc/keystone/keystone.conf

keystone-manage pki_setup --keystone-user keystone --keystone-group keystone:
  cmd.run:
    - creates: /etc/keystone/ssl

/etc/httpd/conf.d/wsgi-keystone.conf:
  file.managed:
    - source: salt://keystone/wsgi-keystone.conf

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


{% if pillar['debug-configonly'] == False %}
openstack-keystone:
    - require_in:
      - ini: /etc/keystone/keystone.conf
      - file: /var/log/keystone
      - file: /etc/keystone/ssl
      - cmd: openstack-keystone
  cmd.run:
    - name: su -s /bin/sh -c "keystone-manage db_sync" keystone
    - stateful: True
keystone-identity-service:
  cmd.run:
    - name: openstack service create --type identity   --description "OpenStack Identity" keystone
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q keystone
    - requires:
      - service: openstack-keystone-httpd
      - pkg: python-openstackclient
keystone-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['keystonepublichost'] }}:5000/v2.0 --internalurl https://{{ pillar['keystonehost'] }}:5000/v2.0 --adminurl https://{{ pillar['keystonehost'] }}:35357/v2.0 --region RegionOne identity
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q keystone
    - requires:
      - service: openstack-keystone-httpd
      - pkg: python-openstackclient
admin-project:
  cmd.run:
    - name: openstack project create --description "Admin Project" admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack project list | grep  -q admin
    - requires:
      - service: openstack-keystone-httpd
      - pkg: python-openstackclient
admin-user:
  cmd.run:
    - name: openstack user create --password {{pillar['admin_pass']}} admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q admin
    - requires:
      - cmd: openstack-keystone
      - pkg: python-openstackclient
admin-role:
  cmd.run:
    - name: openstack role create admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack role list | grep  -q admin
    - requires:
      - service: openstack-keystone-httpd
      - pkg: python-openstackclient
admin-role-project:
  cmd.run:
    - name: openstack role add --project admin --user admin admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list admin --project admin | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: admin-user
      - cmd: admin-project
      - pkg: python-openstackclient
service-project:
  cmd.run:
    - name: openstack project create --description "Service Project" service
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack project list | grep  -q service
    - requires:
      - service: openstack-keystone-httpd
      - pkg: python-openstackclient
{% endif %}


{% if pillar['debug-configonly'] == False %}
keystone_services:
  service.running:
    - name: memcached
    - name: httpd
{% endif %}
