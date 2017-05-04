/etc/murano/murano.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          verbose: True
          debug: True
          my_ip: {{ pillar['muranoprivatehost'] }}
        oslo_messaging_notifications:
          driver: messagingv2
        database:
          connection: mysql://murano:{{ pillar['murano_dbpass'] }}@{{ pillar['mysqlhost'] }}/murano
        keystone_authtoken:
          memcached_servers: {{ pillar['memcached_servers'] }} 
          token_cache_time: 3600
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: murano
          password: {{ pillar['murano_pass'] }}
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        engine:
          workers: 4
        networking:
          external_network: public
        rabbitmq:
          ssl: True
          password: {{ pillar['murano_guest_rabbitmq_pass'] }}
          user: murano
          host: jblb.jetstream-cloud.org
          virtual_host: murano
  file.managed:
    - user: murano
    - group: murano
