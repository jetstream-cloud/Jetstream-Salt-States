neutron-user:
  cmd.run:
    - name: openstack user create --password {{pillar['neutron_pass']}} neutron
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user list | grep  -q neutron
neutron-role-project:
  cmd.run:
    - name: openstack role add --project service --user neutron admin
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack user role list neutron --project service | grep  -q admin
    - requires:
      - cmd: neutron-user
neutron-service:
  cmd.run:
    - name: openstack service create --type network --description "OpenStack Networking" neutron
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack service list | grep  -q network
neutron-endpoint:
  cmd.run:
    - name: openstack endpoint create --publicurl https://{{ pillar['neutronpublichost'] }}:9696 --adminurl http://{{ pillar['neutronprivatehost'] }}:9696 --internalurl http://{{ pillar['neutronprivatehost'] }}:9696 --region RegionOne network
    - env:
      - OS_URL: https://{{ pillar['keystonehost'] }}:35357/v2.0
      - OS_TOKEN: {{ pillar['admin_token'] }}
    - unless: openstack endpoint list | grep  -q network
      
