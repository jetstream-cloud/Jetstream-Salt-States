/etc/senlin/senlin.conf:
  ini.options_present:
      - separator: '='
      - sections:
          database:
            connection: mysql+pymsql://senlin:{{ pillar['senlin_dbpass'] }}@{{ pillar['dbhost'] }}/senlin?charset=utf8
          keystone_authtoken:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000/v3
            auth_version: 3
            identity_uri: https://{{ pillar['keystonehost'] }}:35357
            admin_user: senlin
            admin_password: {{ pillar['senlin_pass'] }}
            admin_tenant_name: service
          authentication:
            auth_url: https://{{ pillar['keystonehost'] }}:5000/v3
            service_username: senlin
            service_password: {{ pillar['senlin_pass'] }}
            service_project_name: service
          oslo_messaging_rabbit:
            rabbit_userid: openstack
            rabbit_hosts: {{ pillar['rabbit_hosts'] }}
            rabbit_password: {{ pillar['rabbit_pass'] }}
          oslo_messaging_notifications:
            driver: messaging
