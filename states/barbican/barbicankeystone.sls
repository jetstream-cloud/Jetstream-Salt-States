barbican-user:
  keystone.user_present:
    - name: barbican
    - password: {{pillar['barbican_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

barbican-service:
  keystone.service_present:
    - name: barbican
    - service_type: key-manager
    - description: Key Manager


barbican-pubilc-endpoint:
 keystone.endpoint_present:
    - name: key-manager
    - url: https://{{ pillar['barbicanpublichost'] }}:9311/v1/%\(tenant_id\)s
    - interface: public
    - region: RegionOne

barbican-internal-endpoint:
 keystone.endpoint_present:
    - name: key-manager
    - url: https://{{ pillar['barbicanpublichost'] }}:9311/v1/%\(tenant_id\)s
    - interface: internal
    - region: RegionOne

barbican-admin-endpoint:
 keystone.endpoint_present:
    - name: key-manager
    - url: https://{{ pillar['barbicanpublichost'] }}:9311/v1/%\(tenant_id\)s
    - interface: admin
    - region: RegionOne
