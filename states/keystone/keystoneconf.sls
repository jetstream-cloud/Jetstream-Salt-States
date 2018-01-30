/etc/keystone/domains/keystone.tacc.conf:
  ini.options_present:
    - sections:
        identity:
          driver: keystone.identity.backends.ldap.Identity
        ldap:
          user_attribute_ignore: description
          debug_level: -1
          url: ldap://localhost
          user: cn=Manager,dc=tacc,dc=utexas,dc=edu
          password: {{ pillar['ldap_password'] }}
          suffix: dc=tacc,dc=utexas,dc=edu
          use_dumb_member: false
          allow_subtree_delete: false
          tls_cacertfile: /etc/pki/tls/certs/incommon-ssl.ca-bundle
          use_tls: false
          tls_req_cert: allow
          query_scope: sub
          use_pool: true
          user_tree_dn: dc=tacc,dc=utexas,dc=edu
          user_filter: (host=jetstream.tacc.utexas.edu)
          user_objectclass: inetOrgPerson
          user_id_attribute: uid
          user_name_attribute: uid
          user_mail_attribute: mail
          user_pass_attribute: userPassword
          user_enabled_attribute: gidNumber
          user_enabled_default: 1
          user_enabled_mask: 65535
          user_enabled_invert: true
          user_allow_create: false
          project_tree_dn: ou=Jetstream,ou=Systems,dc=tacc,dc=utexas,dc=edu
          project_objectclass: groupOfNames
          project_id_attribute: cn
          project_member_attribute: member
          project_name_attribute: cn
          project_enabled_attribute: true
          project_desc_attribute: description
          project_allow_create: false
          project_allow_update: false
          project_allow_delete: false
          group_tree_dn: ou=Jetstream,ou=Systems,dc=tacc,dc=utexas,dc=edu
          group_objectclass: groupOfNames
          group_id_attribute: cn
          group_member_attribute: member
          group_name_attribute: cn
          group_enabled_attribute: true
          group_desc_attribute: description
          group_allow_create: false
          group_allow_update: false
          group_allow_delete: false
          role_tree_dn: ou=Roles,ou=Jetstream,ou=Systems,dc=tacc,dc=utexas,dc=edu
          role_allow_create: false
          role_allow_update: false
          role_allow_delete: false

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
           connection: mysql+pymysql://keystone:{{ pillar['keystone_dbpass'] }}@{{ pillar['mysqlhost'] }}/keystone
        revoke:
           driver: sql
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
           domain_config_dir: /etc/keystone/domains
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
