sahara-user:
  keystone.user_present:
    - name: sahara
    - password: {{pillar['sahara_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

sahara-service:
  keystone.service_present:
    - name: sahara
    - service_type: data-processing 
    - description: Sahara Data Processing


sahara-pubilc-endpoint:
 keystone.endpoint_present:
    - name: data-processing 
    - url: https://{{ pillar['saharapublichost'] }}:8386/v1.1/%\(project_id\)s
    - interface: public
    - region: RegionOne

sahara-internal-endpoint:
 keystone.endpoint_present:
    - name: data-processing
    - url: https://{{ pillar['saharapublichost'] }}:8386/v1.1/%\(project_id\)s
    - interface: internal
    - region: RegionOne

sahara-admin-endpoint:
 keystone.endpoint_present:
    - name: data-processing
    - url: https://{{ pillar['saharapublichost'] }}:8386/v1.1/%\(project_id\)s
    - interface: admin
    - region: RegionOne
