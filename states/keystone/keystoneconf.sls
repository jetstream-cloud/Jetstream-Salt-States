/etc/keystone/keystone.conf:
  ini.options_present:
    - sections:
        DEFAULT:
           debug: 'True'
           admin_token: {{ pillar['admin_token'] }}
           log_dir: /var/log/keystone
           secure_proxy_ssl_header: "HTTP_X_FORWARDED_PROTO"
           rpc_backend: rabbit
           notification_driver: messagingv2
        database:
           connection: mysql://keystone:{{ pillar['keystone_dbpass'] }}@{{ pillar['mysqlhost'] }}/keystone
        revoke:
           driver: keystone.contrib.revoke.backends.sql.Revoke
        shadow_users:
           driver: sql
        token:
           provider: keystone.token.providers.uuid.Provider
           driver: memcache_pool 
        memcache:
           servers: {{ pillar['memcached_servers'] }}   
        identity:
           domain_specific_drivers_enabled: true
           default_domain_name: Default
        cache:
           expiration_time: 3600
           backend: oslo_cache.memcache_pool
           memcache_servers: {{ pillar['memcached_servers'] }}
        resource:
          admin_project_domain_name: default
          admin_project_name: admin
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
