cinder-user:
  keystone.user_present:
    - name: cinder
    - password: {{pillar['ceilometer_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

cinder-service:
  keystone.service_present:
    - name: cinder
    - service_type: volume
    - description: OpenStack Block Storage

cinderv2-service:
  keystone.service_present:
    - name: cinderv2
    - service_type: volumev2
    - description: OpenStack Block Storage

cinder-public-endpoint:
 keystone.endpoint_present:
    - name: volume
    - url: https://{{ pillar['cinderpublichost'] }}:8776/v1/%\(tenant_id\)s
    - interface: public
    - region: RegionOne
cinder-private-endpoint:
 keystone.endpoint_present:
    - name: volume
    - url: https://{{ pillar['cinderprivatehost'] }}:8776/v1/%\(tenant_id\)s
    - interface: private
    - region: RegionOne
cinder-admin-endpoint:
 keystone.endpoint_present:
    - name: volume
    - url: https://{{ pillar['cinderprivatehost'] }}:8776/v1/%\(tenant_id\)s
    - interface: admin
    - region: RegionOne

cinderv2-public-endpoint:
 keystone.endpoint_present:
    - name: volume
    - url: https://{{ pillar['cinderpublichost'] }}:8776/v2/%\(tenant_id\)s
    - interface: public
    - region: RegionOne
cinderv2-private-endpoint:
 keystone.endpoint_present:
    - name: volume
    - url: https://{{ pillar['cinderprivatehost'] }}:8776/v2/%\(tenant_id\)s
    - interface: private
    - region: RegionOne
cinderv2-endpoint:
 keystone.endpoint_present:
    - name: volume
    - url: https://{{ pillar['cinderprivatehost'] }}:8776/v2/%\(tenant_id\)s
    - interface: admin
    - region: RegionOne

