

openstack-manila:
  pkg:
    - installed
    - required_in:
      - ini: /etc/manila/manila.conf
  cmd.run:
    - name: su -s /bin/sh -c "manila-db-manage upgrade head" manila
    - stateful: True
    - require:
      - pkg: openstack-manila
      - ini: /etc/manila/manila.conf

openstack-manila-api:
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/manila/manila.conf
    - require:
      - cmd: openstack-manila
openstack-manila-engine:
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/manila/manila.conf
    - require:
      - cmd: openstack-manila

/etc/manila/manila.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            debug: True
            verbose: True
            rpc_backend: rabbit
            default_share_type: default_share_type
            share_name_template: share-%s
            rootwrap_config: /etc/manila/rootwrap.conf
            api_paste_config: /etc/manila/api-paste.ini
            auth_strategy: keystone
            transport_url: rabbit://openstack:{{ pillar['openstack_rabbit_pass'] }}@172.16.128.253:5672,openstack:{{ pillar['openstack_rabbit_pass'] }}@172.16.128.252:5672,openstack:{{ pillar['openstack_rabbit_pass'] }}@172.16.128.250:5672
            my_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}
            driver_handles_share_servers: True
            enabled_share_backends: generic
            enabled_share_protocols: NFS
          database:
            connection: mysql+pymysql://manila:{{ pillar['manila_dbpass']}}@{{ pillar['mysqlhost'] }}/manila
          oslo_concurrency:
            lock_path: /var/lock/manila
          keystone_authtoken:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211
            auth_type: password
            project_domain_name: default
            user_domain_name: default
            project_name: service
            username: manila
            password: {{ pillar['manila_pass'] }}
          neutron:
            url: https://{{ pillar['neutronpublichost'] }}:9696
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211
            auth_type: password
            project_domain_name: default
            user_domain_name: default
            region_name: RegionOne
            project_name: service
            username: neutron
            password: {{ pillar['neutron_pass'] }}
          nova:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211
            auth_type: password
            project_domain_name: default
            user_domain_name: default
            region_name: RegionOne
            project_name: service
            username: nova
            password: {{ pillar['nova_pass'] }}
          cinder:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211
            auth_type: password
            project_domain_name: default
            user_domain_name: default
            region_name: RegionOne
            project_name: service
            username: cinder
            password: {{ pillar['cinder_pass'] }}
          generic:
            share_backend_name: GENERIC
            share_driver: manila.share.drivers.generic.GenericShareDriver
            driver_handles_share_servers: True
            service_instance_flavor_id: 100
            service_image_name: manila-service-image
            service_instance_user: manila
            service_instance_password: manila
            interface_driver: manila.network.linux.interface.BridgeInterfaceDriver
