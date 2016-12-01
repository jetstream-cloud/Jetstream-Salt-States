openstack-mistral-api:
  pkg.installed
openstack-mistral-engine:
  pkg.installed
openstack-mistral-executor:
  pkg.installed
openstack-mistral-all:
  pkg.installed

/etc/mistral/mistral.conf:
  ini.options_present:
      - sections:
        DEFAULT:
          debug: True
          verbose: True
        database:
          connection: mysql://mistral:{{ pillar['mistral_dbpass']}}@{{ pillar['mysqlhost'] }}/mistral
        oslo_messaging_notifications:
          driver: messagingv2
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        keystone_authtoken:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: mistral
          password: {{ pillar['mistral_pass'] }}
        pecan:
          auth_enable: True
