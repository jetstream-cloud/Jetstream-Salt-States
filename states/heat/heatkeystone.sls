heat-user:
  cmd.run:
    - name: openstack user create --password {{pillar['heat_pass']}} heat
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q heat

heat-role-project:
  cmd.run:
    - name: openstack role add --project service --user heat admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list heat --project service | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: heat-user
      - cmd: service-project
heat-service:
  cmd.run:
    - name: openstack service create --name heat  --description "Orchestration" orchestration
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep -v heat-cfn |grep -q heat
heat-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['heathost'] }}:8004/ --internalurl https://{{ pillar['heathost'] }}:8004/ --adminurl https://{{ pillar['heathost'] }}:8004/ --region RegionOne orchestration 
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q heat 

heat-cfn-service:
  cmd.run:
    - name: openstack service create --name heat-cfn  --description "Orchestration" cloudformation
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep -q heat-cfn
heat-cfn-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['heathost'] }}:8000/ --internalurl https://{{ pillar['heathost'] }}:8000/ --adminurl https://{{ pillar['heathost'] }}:8000/ --region RegionOne cloudformation 
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q heat

heat-domain:
  cmd.run:
    - name: openstack domain create --description "Stack projects and users" heat
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack domain list |grep -q heat

heat-domain-admin:
  cmd.run:
    - name: openstack user create --domain heat -password {{pillar['heat_domain_admin_pass']}} heat_domain_admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list --domain heat | grep  -q heat_domain_admin
heat-domain-admin-role:
  cmd.run:
    - name: openstack role add --domain heat --user heat_domain_admin admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
heat_stack_owner_role:
  cmd.run:
    - name: openstack role create heat_stack_owner
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack role list |grep heat_stack_owner
heat_stack_user_role:
  cmd.run:
    - name: openstack role create heat_stack_user
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack role list |grep heat_stack_user
