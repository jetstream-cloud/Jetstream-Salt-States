/etc/glance/glance-registry.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            verbose: True
            notification_driver: noop
          database:
            connection: mysql://glance:{{ pillar['glance_dbpass'] }}@{{ pillar['mysqlhost'] }}/glance
          keystone_authtoken:
            auth_uri: http://{{ pillar['keystonehost'] }}:5000
            auth_url: http://{{ pillar['keystonehost'] }}:35357
            auth_plugin: password
            project_domain_id: default
            user_domain_id: default
            project_name: service
            username: glance
            password: {{ pillar['glance_pass'] }}
          paste_deploy:
            flavor: keystone
