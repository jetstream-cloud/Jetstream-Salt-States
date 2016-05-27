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

/etc/ufw/applications.d/horizon:
  file.managed:
    - source: salt://haproxy/horizon.ufw.app
    - require_in:
      - cmd: horizon_ufw_rule
horizon_ufw_rule:
  cmd.run:
    - name: ufw allow horizon
    - unless: ufw status verbose | grep -q '443/tcp (horizon)          ALLOW IN    Anywhere'

/etc/ufw/applications.d/gnocchi-api:
  file.managed:
    - source: salt://haproxy/gnocchi-api.ufw.app
    - require_in:
      - cmd: gnocchi-api_ufw_rule
gnocchi-api_ufw_rule:
  cmd.run:
    - name: ufw allow gnocchi-api
    - unless: ufw status verbose | grep -q '8041/tcp (gnocchi-api)      ALLOW IN    Anywhere'

/etc/ufw/applications.d/heat-api:
  file.managed:
    - source: salt://haproxy/heat-api.ufw.app
    - require_in:
      - cmd: heat-api_ufw_rule
heat-api_ufw_rule:
  cmd.run:
    - name: ufw allow heat-api
    - unless: ufw status verbose | grep -q '8004/tcp (heat-api)         ALLOW IN    Anywhere'

/etc/ufw/applications.d/heat-api-cfn:
  file.managed:
    - source: salt://haproxy/heat-api-cfn.ufw.app
    - require_in:
      - cmd: heat-api-cfn_ufw_rule
heat-api-cfn_ufw_rule:
  cmd.run:
    - name: ufw allow heat-api-cfn
    - unless: ufw status verbose | grep -q '8000/tcp (heat-api-cfn)     ALLOW IN    Anywhere'

/etc/ufw/applications.d/ceilometer-api:
  file.managed:
    - source: salt://haproxy/ceilometer-api.ufw.app
    - require_in:
      - cmd: ceilometer-api_ufw_rule
ceilometer-api_ufw_rule:
  cmd.run:
    - name: ufw allow ceilometer-api
    - unless: ufw status verbose | grep -q '8777/tcp (ceilometer-api)      ALLOW IN    Anywhere'


/etc/ufw/applications.d/glance-api:
  file.managed:
    - source: salt://haproxy/glance-api.ufw.app
    - require_in:
      - cmd: glance-api_ufw_rule
glance-api_ufw_rule:
  cmd.run:
    - name: ufw allow glance-api
    - unless: ufw status verbose | grep -q '9292/tcp (glance-api)      ALLOW IN    Anywhere'

/etc/ufw/applications.d/glance-regsitry:
  file.managed:
    - source: salt://haproxy/glance-registry.ufw.app
    - require_in:
      - cmd: glance-registry_ufw_rule
glance-registry_ufw_rule:
  cmd.run:
    - name: ufw allow glance-registry
    - unless: ufw status verbose | grep -q '9191/tcp (glance-registry) ALLOW IN    Anywhere'

/etc/ufw/applications.d/cinder-api:
  file.managed:
    - source: salt://haproxy/cinder-api.ufw.app
    - require_in:
      - cmd: cinder-api_ufw_rule
cinder-api_ufw_rule:
  cmd.run:
    - name: ufw allow cinder-api
    - unless: ufw status verbose | grep -q '8776/tcp (cinder-api)      ALLOW IN    Anywhere'

/etc/ufw/applications.d/swift:
  file.managed:
    - source: salt://haproxy/swift.ufw.app
    - require_in:
      - cmd: swift_ufw_rule
swift_ufw_rule:
  cmd.run:
    - name: ufw allow swift
    - unless: ufw status verbose | grep -q '8080/tcp (swift)           ALLOW IN    Anywhere'

/etc/ufw/applications.d/nova-api:
  file.managed:
    - source: salt://haproxy/nova-api.ufw.app
    - require_in:
      - cmd: nova-api_ufw_rule
nova-api_ufw_rule:
  cmd.run:
    - name: ufw allow nova-api
    - unless: ufw status verbose | grep -q '8774/tcp (Nova-api)        ALLOW IN    Anywhere'

/etc/ufw/applications.d/nova-ec2:
  file.managed:
    - source: salt://haproxy/nova-ec2.ufw.app
    - require_in:
      - cmd: nova-ec2_ufw_rule
nova-ec2_ufw_rule:
  cmd.run:
    - name: ufw allow nova-ec2
    - unless: ufw status verbose | grep -q '8773/tcp (Nova-ec2)        ALLOW IN    Anywhere'


/etc/ufw/applications.d/nova-metadata:
  file.managed:
    - source: salt://haproxy/nova-metadata.ufw.app
    - require_in:
      - cmd: nova-metadata_ufw_rule
nova-metadata_ufw_rule:
  cmd.run:
    - name: ufw allow nova-metadata
    - unless: ufw status verbose | grep -q '8775/tcp (Nova-Metadata)   ALLOW IN    Anywhere'

/etc/ufw/applications.d/neutron:
  file.managed:
    - source: salt://haproxy/neutron.ufw.app
    - require_in:
      - cmd: neutron_ufw_rule
neutron_ufw_rule:
  cmd.run:
    - name: ufw allow Neutron
    - unless: ufw status verbose | grep -q '9696/tcp (Neutron)         ALLOW IN    Anywhere'

mysql_ufw_rule:
  cmd.run:
    - name: ufw allow from 172.16.128.0/20 to any port 3306 proto tcp
    - unless: ufw status verbose | grep -q '3306/tcp                   ALLOW IN    172.16.128.0/20'

/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/haproxy.cfg
    - template: jinja
    - context:
      statsauth: {{ pillar['lbstatsauth'] }}
haproxy:
  pkg.installed:
    - require_in:
      - file: /etc/haproxy/haproxy.cfg
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
