/etc/glance/glance-registry.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            verbose: True
            notification_driver: noop
          database:
            connection: mysql://glance:{{ pillar['glance_dbpass'] }}@localhost/glance
          keystone_authtoken:
            auth_uri: http://172.16.128.2:5000
            auth_url: http://172.16.128.2:35357
            auth_plugin: password
            project_domain_id: default
            user_domain_id: default
            project_name: service
            username: glance
            password: {{ pillar['glance_pass'] }}
          paste_deploy:
            flavor: keystone