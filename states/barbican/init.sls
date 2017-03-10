
openstack-barbican-api:
  pkg:
    - name: {{ pillar['openstack-barbican-api'] }}
    - installed
    - required_in:
      - ini: /etc/barbican/barbican.conf
      - ini: /etc/barbican/barbican-api-paste.ini
  cmd.run:
    - name: su -s /bin/sh -c "barbican-manage db_sync" glance
    - stateful: True
    - require:
      - pkg: openstack-barbican
      - ini: /etc/barbican/barbican.conf

/etc/barbican/barbican.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            rpc_backend: rabbit
          database:
            connection: mysql://barbican:{{ pillar['barbican_dbpass']}}@{{ pillar['mysqlhost'] }}/barbican
          oslo_messaging_rabbit:
            rabbit_ha_queues: True
            rabbit_hosts: {{ pillar['rabbit_hosts'] }}
            rabbit_userid: openstack
            rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
          keystone_authtoken:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211
            auth_type: password
            project_domain_name: default
            user_domain_name: default
            project_name: service
            username: barbican
            password: {{ pillar['barbican_pass'] }}

/etc/barbican/barbican-api-paste.ini:
  ini.options_present:
    - sections:
          "pipeline:barbican_api":
             pipeline: cors authtoken context apiapp

/etc/httpd/conf.d/wsgi-barbican.conf:
  file.managed:
    - source: salt://barbican/wsgi-barbican.conf
