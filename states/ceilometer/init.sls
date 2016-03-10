openstack-ceilometer-api:
  pkg.installed
openstack-ceilometer-collector:
  pkg.installed
openstack-ceilometer-notification:
  pkg.installed
openstack-ceilometer-central: 
  pkg.installed
openstack-ceilometer-alarm:
  pkg.installed
python-ceilometerclient:
  pkg.installed

/etc/ceilometer/ceilometer.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          verbose: True
          dispatcher: gnocchi
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
          username: ceilometer
          password: {{ pillar['ceilometer_pass'] }}
        service_credentials:
          os_auth_url: https://{{ pillar['keystonehost'] }}:5000
          os_username: ceilometer
          os_tenant_name: service
          os_password: {{ pillar['ceilometer_pass'] }}
          os_endpoint_type = internalURL
          os_region_name = RegionOne
