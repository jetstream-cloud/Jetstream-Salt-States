trove-user:
  keystone.user_present:
    - name: trove
    - password: {{pillar['trove_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

trove-service:
  keystone.service_present:
    - name: trove
    - service_type: database 
    - description: Database


trove-pubilc-endpoint:
 keystone.endpoint_present:
    - name: database 
    - url: https://{{ pillar['trovepublichost'] }}:8779/v1.0/%\(tenant_id\)s
    - interface: public
    - region: RegionOne

trove-internal-endpoint:
 keystone.endpoint_present:
    - name: database
    - url: https://{{ pillar['trovepublichost'] }}:8779/v1.0/%\(tenant_id\)s
    - interface: internal
    - region: RegionOne

trove-admin-endpoint:
 keystone.endpoint_present:
    - name: database
    - url: https://{{ pillar['trovepublichost'] }}:8779/v1.0/%\(tenant_id\)s
    - interface: admin
    - region: RegionOne
