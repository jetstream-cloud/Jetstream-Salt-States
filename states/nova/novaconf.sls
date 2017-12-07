/etc/nova/nova.conf-absent:
  ini.options_absent:
      - name: /etc/nova/nova.conf
      - sections:
          neutron:
            - admin_auth_url
            - admin_tenant_name
            - admin_username
            - admin_password
            - auth_strategy
          glance:
            - host
            - port
            - protocol
          DEFAULT:
            - network_api_class
            - security_group_api
            - memcached_servers
            - ec2_workers
            - notification_driver
          keystone_authtoken:
            - auth_plugin
/etc/nova/nova.conf:
  ini.options_present:
    - separator: '='
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          my_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }} 
          vncserver_listen: {{ pillar['novaprivatehost'] }}
          vncserver_proxyclient_address: {{ pillar['novaprivatehost'] }}
          verbose: True
          linuxnet_interface_driver: nova.network.linux_net.LinuxBridgeInterfaceDriver
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
          osapi_compute_workers: 4
          metadata_workers: 4
          ram_allocation_ratio: 1
          ram_weight_multiplier: -1.0
          use_neutron: True
          reserved_host_memory_mb: 1536
          vendordata_providers: StaticJSON
          vendordata_jsonfile_path: /etc/nova/vendordata.json
          osapi_max_limit: 10000
        conductor:
          workers: 4
        database:
          connection: mysql+pymysql://nova:{{ pillar['nova_dbpass']}}@{{ pillar['mysqlhost'] }}/nova
        api_database:
          connection: mysql+pymysql://nova:{{ pillar['nova_dbpass']}}@{{ pillar['mysqlhost'] }}/nova_api
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        oslo_messaging_notifications:
          driver: messagingv2
        keystone_authtoken:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_type: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: nova
          password: {{ pillar['nova_pass'] }}
          memcached_servers: {{ pillar['memcached_servers'] }} 
        glance:
          api_servers: https://{{ pillar['glancepublichost'] }}:9292
        oslo_concurrency:
          lock_path: /var/lock/nova
        neutron:
          url: https://{{ pillar['neutronpublichost'] }}:9696
          auth_type: password
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          project_name: service
          project_domain_name: default
          user_domain_name: default
          region_name: RegionOne
          username: neutron
          password: {{ pillar['neutron_pass'] }} 
          metadata_proxy_shared_secret: {{ pillar['metadata_proxy_shared_secret'] }}
          service_metadata_proxy: True
        vnc:
          enabled: True
          novncproxy_base_url: https://{{ pillar['novapublichost'] }}:6080/vnc_auto.html
          vncserver_listen: 0.0.0.0
          vncserver_proxyclient_address: 127.0.0.1
          xvpvncproxy_base_url: https://{{ pillar['novapublichost'] }}:6081/console
        cache:
          memcache_servers: {{ pillar['memcached_servers'] }}
          backend: oslo_cache.memcache_pool
          enabled: true
        placement:
          os_region_name: RegionOne
          auth_type: password
          auth_url: https://{{ pillar['keystonehost'] }}:35357/v3
          project_name: service
          project_domain_name: Default
          username: placement
          user_domain_name: Default
          password: {{ pillar['placement_pass'] }}
        placement_database:
          connection: mysql+pymysql://nova:{{ pillar['nova_dbpass'] }}@{{ pillar['mysqlhost'] }}/nova_api
