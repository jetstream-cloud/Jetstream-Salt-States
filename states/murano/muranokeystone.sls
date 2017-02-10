murano-user:
  keystone.user_present:
    - name: murano
    - password: {{pillar['murano_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

murano-service:
  keystone.service_present:
    - name: murano 
    - service_type: application-catalog 
    - description: Application Catalog for OpenStack

murano-endpoint:
  keystone.endpoint_present:
    - name: murano
    - url: https://{{ pillar['muranopublichost'] }}:8082
    - interface: public
    - region: RegionOne

