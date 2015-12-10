/etc/ufw/applications.d/keystone:
  file.managed:
    - source: salt://haproxy/keystone.ufw.app
    - require_in:
      - cmd: keystone_ufw_rule
keystone_ufw_rule:
  cmd.run:
    - name: ufw allow keystone
    - unless: ufw status verbose | grep -q '5000/tcp (keystone)        ALLOW IN    Anywhere'

/etc/ufw/applications.d/keystone-admin:
  file.managed:
    - source: salt://haproxy/keystone-admin.ufw.app
    - require_in:
      - cmd: keystone-admin_ufw_rule
keystone-admin_ufw_rule:
  cmd.run:
    - name: ufw allow keystone-admin
    - unless: ufw status verbose | grep -q '35357/tcp (keystone-admin) ALLOW IN    Anywhere'

/etc/ufw/applications.d/glance-api:
  file.managed:
    - source: salt://haproxy/glance-api.ufw.app
    - require_in:
      - cmd: glance-api_ufw_rule
glance-api_ufw_rule:
  cmd.run:
    - name: ufw allow glance-api
    - unless: ufw status verbose | grep -q '9292/tcp (glance-api)     ALLOW IN    Anywhere'

/etc/ufw/applications.d/glance-regsitry:
  file.managed:
    - source: salt://haproxy/glance-registry.ufw.app
    - require_in:
      - cmd: glance-registry_ufw_rule
glance-registry_ufw_rule:
  cmd.run:
    - name: ufw allow glance-registry
    - unless: ufw status verbose | grep -q '9292/tcp (glance-registry) ALLOW IN    Anywhere'

/etc/ufw/applications.d/cinder-api:
  file.managed:
    - source: salt://haproxy/cinder-api.ufw.app
    - require_in:
      - cmd: cinder-api_ufw_rule
cinder-api_ufw_rule:
  cmd.run:
    - name: ufw allow cinder-api
    - unless: ufw status verbose | grep -q '9292/tcp (cinder-api)     ALLOW IN    Anywhere'

mysql_ufw_rule:
  cmd.run:
    - name: ufw allow from 172.16.128.0/20 to any port 3306 proto tcp
    - unless: ufw status verbose | grep -q '3306/tcp                   ALLOW IN    172.16.128.0/20'

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/haproxy.cfg

haproxy:
  pkg.installed:
    - require_in:
      - file: /etc/haproxy/haproxy.cfg
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
