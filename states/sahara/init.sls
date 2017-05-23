

openstack-sahara:
  pkg:
    - installed
    - required_in:
      - ini: /etc/sahara/sahara.conf
  cmd.run:
    - name: su -s /bin/sh -c "sahara-db-manage upgrade head" sahara
    - stateful: True
    - require:
      - pkg: openstack-sahara
      - ini: /etc/sahara/sahara.conf

openstack-sahara-api:
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/sahara/sahara.conf
    - require:
      - cmd: openstack-sahara
openstack-sahara-engine:
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/sahara/sahara.conf
    - require:
      - cmd: openstack-sahara

/etc/sahara/sahara.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            debug: True
            verbose: True
            rpc_backend: rabbit
            use_neutron: True
            use_namespaces: True
            use_rootwrap: True
          database:
            connection: mysql+pymysql://sahara:{{ pillar['sahara_dbpass']}}@{{ pillar['mysqlhost'] }}/sahara
          oslo_messaging_notifications:
            driver: messagingv2
            enable: True
          oslo_messaging_rabbit:
            rabbit_ha_queues: True
            rabbit_hosts: {{ pillar['rabbit_hosts'] }}
            rabbit_userid: openstack
            rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
          keystone_authtoken:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            memcached_servers: {{ pillar['memcached_servers'] }}
            auth_type: password
            project_domain_name: default
            user_domain_name: default
            project_name: service
            username: sahara
            password: {{ pillar['sahara_pass'] }}
            admin_tenant_name: service
            admin_user: sahara
            admin_password: {{ pillar['sahara_pass'] }}
