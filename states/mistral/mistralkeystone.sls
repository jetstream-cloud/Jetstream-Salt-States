mistral-user:
  keystone.user_present:
    - password: {{pillar['mistral_pass']}}
    - email: jethelp@jetstream-cloud.org
    - roles:
        service:
          - admin

mistral-service:
  keystone.service_present:
    - name: mistral
    - service_type: workflow
    - description: OpenStack Workflow service

mistral-endpoint:
  keystone.endpoint_present:
    - name: mistral
    - url: https://{{ pillar['mistralpublichost'] }}:8989/v2
    - interface: public
