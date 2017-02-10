glance-user:
  keystone.user_present:
    - name: glance
    - password: {{pillar['glance_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

glance-service:
  keystone.service_present:
    - name: glance
    - service_type: image 
    - description: OpenStack Image Service

glance-public-endpoint:
  keystone.endpoint_present:
    - name: image
    - url: https://{{ pillar['glancepublichost'] }}:9292
    - interface: public
    - region: RegionOne
glance-private-endpoint:
  keystone.endpoint_present:
    - name: image
    - url: https://{{ pillar['glancepublichost'] }}:9292
    - interface: private
    - region: RegionOne
glance-admin-endpoint:
  keystone.endpoint_present:
    - name: image
    - url: https://{{ pillar['glancepublichost'] }}:9292
    - interface: admin
    - region: RegionOne
