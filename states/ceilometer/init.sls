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
          debug: true
          rpc_backend: rabbit
          auth_strategy: keystone
          verbose: True
          dispatcher: gnocchi
          notification_driver: messagingv2
          host: {{ grains['id'] }}
          meter_dispatchers: gnocchi
          event_dispatchers: database
        api:
          gnocchi_is_enabled: true
        alarms:
          gnocchi_url: {{ pillar['gnocchi_url'] }}}
        alarm:
          gnocchi_url: {{ pillar['gnocchi_url'] }}}
        notification:
          workers: 8
          batch_size: 16
          batch_timeout: 300
          store_events: true
          workload_partitioning: true 
        collector:
          workers: 16
        coordination:
          backend_url = {{ pillar['zookeeper_url'] }}
        dispatcher_gnocchi:
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
          connection = mysql://ceilometer:{{ pillar['ceilometer_dbpass']}}@{{ pillar['mysqlhost'] }}/ceilometer
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
          auth_url: https://{{ pillar['keystonehost'] }}:5000/v3
          username: ceilometer
          user_domain_name: default
          project_domain_id: default
          project: service
          password: {{ pillar['ceilometer_pass'] }}
          interface: publicURL
          region_name: RegionOne
