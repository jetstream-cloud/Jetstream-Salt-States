/etc/keystone/keystone.conf:
  ini.options_present:
    - sections:
        DEFAULT:
           debug: 'True'
           admin_token: {{ pillar['admin_token'] }}
           log_dir: /var/log/keystone
           secure_proxy_ssl_header: "HTTP_X_FORWARDED_PROTO"
        database:
           connection: mysql://keystone:{{ pillar['keystone_dbpass'] }}@{{ pillar['mysqlhost'] }}/keystone
        revoke:
           driver: keystone.contrib.revoke.backends.sql.Revoke
        token:
           provider: keystone.token.providers.uuid.Provider
           driver: keystone.token.persistence.backends.memcache.Token
        memcache:
           servers: localhost:11211   
        
