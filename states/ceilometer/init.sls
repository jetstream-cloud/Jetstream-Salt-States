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

/etc/ceilometer/gnocchi_resources.yaml:
  file.managed:
    - source: salt://ceilometer/gnocchi_resources.yaml
/etc/ceilometer/event_definitions.yaml:
  file.managed:
    - source: salt://ceilometer/event_definitions.yaml
/etc/ceilometer/event_pipeline.yaml:
  file.managed:
    - source: salt://ceilometer/event_pipeline.yaml
/etc/ceilometer/meters.yaml:
  file.managed:
    - source: salt://ceilometer/meters.yaml
/etc/ceilometer/pipeline.yaml:
  file.managed:
    - source: salt://ceilometer/pipeline.yaml

/etc/ceilometer/ceilometer.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          verbose: True
          dispatcher: gnocchi
          notification_driver: messagingv2
          host: {{ grains['id'] }}
          meter_dispatchers: gnocchi
        api:
          gnocchi_is_enabled: true
        alarms:
          gnocchi_url: {{ pillar['gnocchi_url'] }}}
        alarm:
          gnocchi_url: {{ pillar['gnocchi_url'] }}}
        notification:
          workers: 4
        collector:
          workers: 16
        dispatcher_gnocchi
          archive_policy: low
          archive_policy_file: gnocchi_archive_policy_map.yaml
          filter_project: gnocchi
          filter_service_activity: False
          resources_definition_file: gnocchi_resources.yaml
          url: {{ pillar['gnocchi_url'] }}}
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        database:
          connection = mysql://nova:{{ pillar['nova_dbpass']}}@{{ pillar['mysqlhost'] }}/nova
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
          os_auth_url: https://{{ pillar['keystonehost'] }}:5000/v2.0
          os_username: ceilometer
          os_tenant_name: service
          os_password: {{ pillar['ceilometer_pass'] }}
          os_endpoint_type: internalURL
          os_region_name: RegionOne
