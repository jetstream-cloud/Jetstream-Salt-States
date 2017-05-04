
openstack-aodh-api:
  pkg:
    - installed
    - require-in:
      - ini: /etc/aodh/aodh.conf
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/aodh/aodh.conf
openstack-aodh-evaluator:
  pkg:
    - installed
    - require-in:
      - ini: /etc/aodh/aodh.conf
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/aodh/aodh.conf
openstack-aodh-notifier:
  pkg:
    - installed
    - require-in:
      - ini: /etc/aodh/aodh.conf
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/aodh/aodh.conf
openstack-aodh-listener:
  pkg:
    - installed
    - require-in:
      - ini: /etc/aodh/aodh.conf
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/aodh/aodh.conf
openstack-aodh-expirer:
  pkg.installed
  

python-ceilometerclient:
  pkg.installed

/etc/aodh/aodh.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backed: rabbit
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        keystone_authtoken:
          auth_uri: https://{{ pillar['keystone_publichost'] }}:5000
          auth_url: https://{{ pillar['keystone_publichost'] }}:35357
          memcached_servers: {{ pillar['memcached_servers'] }}
          auth_type: password
          project_domain_name: default
          user_domain_name: default
          project_name: service
          username: aodh
          password: AODH_PASS          
        service_credentials:
          auth_type: password
          auth_url: https://{{ pillar['keystone_publichost'] }}:5000/v3
          project_domain_name: default
          user_domain_name: default
          project_name: service
          username: aodh
          password: {{ pillar['aodh_pass'] }}
          interface: internalURL
          region_name: RegionOne
        database:
          connection: mysql://aodh:{{ pillar['aodh_dbpass'] }}@{{ pillar['mysqlhost'] }}/aodh

