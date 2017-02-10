ceilometer-user:
  keystone.user_present:
    - name: ceilometer
    - password: {{pillar['ceilometer_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

ceilometer-service:
  keystone.service_present:
    - name: ceilometer
    - service_type: metering
    - description: Telemetry


ceilometer-endpoint:
 keystone.endpoint_present:
    - name: metering 
    - url: https://{{ pillar['ceilometerpublichost'] }}:8777/
    - interface: public
    - region: RegionOne

