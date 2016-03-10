ceilometer-user:
  cmd.run:
    - name: openstack user create --password {{pillar['ceilometer_pass']}} ceilometer
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q ceilometer

ceilometer-role-project:
  cmd.run:
    - name: openstack role add --project service --user ceilometer admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list ceilometer --project service | grep  -q admin
    - requires:
      - cmd: admin-role
      - cmd: ceilometer-user
      - cmd: service-project
ceilometer-service:
  cmd.run:
    - name: openstack service create --name ceilometer  --description "Telemetry" metering
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep -v Telemetry
ceilometer-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['ceilometerpublichost'] }}:8777/ --internalurl https://{{ pillar['ceilometerprivatehost'] }}:8777/ --adminurl https://{{ pillar['ceilometerprivatehost'] }}:8777/ --region RegionOne mertering 
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q ceilometer 

