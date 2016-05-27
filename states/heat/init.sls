heat-api:
  pkg:
    - name: {{ pillar['openstack-heat-api'] }}
    - installed
    - require_in:
      - ini: /etc/heat/heat.conf
      - cmd: openstack-heat-api
  service:
    - name: {{ pillar['openstack-heat-api'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/heat/heat.conf
    - require:
      - cmd: openstack-heat-api
  cmd.run:
    - name: su -s /bin/sh -c "heat-manage db_sync" heat
    - stateful: True
heat-api-cfn:
  pkg:
    - name: {{ pillar['openstack-heat-api-cfn'] }}
    - installed
    - require_in:
      - ini: /etc/heat/heat.conf
  service:
    - name: {{ pillar['openstack-heat-api-cfn'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/heat/heat.conf
    - require:
      - cmd: openstack-heat-api
heat-engine:
  pkg:
    - name: {{ pillar['openstack-heat-engine'] }}
    - installed
    - require_in:
      - ini: /etc/heat/heat.conf
  service:
    - name: {{ pillar['openstack-heat-engine'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/heat/heat.conf
    - require:
      - cmd: openstack-heat-api
python-heatclient:
  pkg:
    installed

/etc/heat/heat.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          heat_metadata_server_url: http://{{ pillar['heathost'] }}:8000
          heat_waitcondition_server_url: http://{{ pillar['heathost'] }}:8000/v1/waitcondition
          stack_domain_admin: heat_domain_admin
          stack_domain_admin_password: {{ pillar['heat_domain_admin_pass'] }}
          stack_user_domain_name: heat
          verbose: True
        database:
          connection: mysql+pymysql://heat:{{ pillar['head_dbpass'] }}@controller/heat
        oslo_messaging_rabbit:
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['rabbit_pass'] }}
        keystone_authtoken:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: heat
          password: {{ pillar['heat_pass'] }}
        trustee:
          auth_plugin: password
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          username: heat
          password: {{ pillar['heat_pass'] }} 
          user_domain_id: default
        clients_keystone:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
        ec2authtoken:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000

