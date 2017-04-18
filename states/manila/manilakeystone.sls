manila-user:
  keystone.user_present:
    - name: manila
    - password: {{pillar['manila_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

manila-service:
  keystone.service_present:
    - name: manila
    - service_type: share
    - description: OpenStack Shared File Systems 

manila-service-v2:
  keystone.service_present:
    - name: manilav2
    - service_type: sharev2
    - description: OpenStack Shared File Systems

manila-pubilc-endpoint:
 keystone.endpoint_present:
    - name: manila 
    - url: https://{{ pillar['manilapublichost'] }}:8786/v1/%\(tenant_id\)s
    - interface: public
    - region: RegionOne

manila-internal-endpoint:
 keystone.endpoint_present:
    - name: manila
    - url: https://{{ pillar['manilapublichost'] }}:8786/v1/%\(tenant_id\)s
    - interface: internal
    - region: RegionOne

manila-admin-endpoint:
 keystone.endpoint_present:
    - name: manila
    - url: https://{{ pillar['manilapublichost'] }}:8786/v1/%\(tenant_id\)s
    - interface: admin
    - region: RegionOne

manila-v2-pubilc-endpoint:
 keystone.endpoint_present:
    - name: sharev2
    - url: https://{{ pillar['manilapublichost'] }}:8786/v2/%\(tenant_id\)s
    - interface: public
    - region: RegionOne

manila-v2-internal-endpoint:
 keystone.endpoint_present:
    - name: sharev2
    - url: https://{{ pillar['manilapublichost'] }}:8786/v2/%\(tenant_id\)s
    - interface: internal
    - region: RegionOne

manila-v2-admin-endpoint:
 keystone.endpoint_present:
    - name: sharev2
    - url: https://{{ pillar['manilapublichost'] }}:8786/v2/%\(tenant_id\)s
    - interface: admin
    - region: RegionOne

