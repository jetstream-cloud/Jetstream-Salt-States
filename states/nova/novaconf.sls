
nova_conf_absent:
  ini.options_absent:
      - require:
        - cleanup_novaconf
      - name: /etc/nova/nova.conf
      - sections:
          neutron:
            - admin_auth_url
            - admin_tenant_name
            - admin_username
            - admin_password
            - auth_strategy
          #glance:
          #  - host
          #  - port
          #  - protocol
          DEFAULT:
            - network_api_class
            - security_group_api
            - memcached_servers

nova_conf_present:
  ini.options_present:
      - require: 
        - cleanup_novaconf
      - name: /etc/nova/nova.conf
      - sections:
          DEFAULT:
            rpc_backend: rabbit
            auth_strategy: keystone
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.' in item %}
    {% set privateip = item %}
            my_ip: {{ privateip }}
  {% endif %}
{% endfor %}
            vncserver_listen: {{ pillar['novaprivatehost'] }}
            vncserver_proxyclient_address: {{ pillar['novaprivatehost'] }}
            verbose: True
            linuxnet_interface_driver: nova.network.linux_net.LinuxBridgeInterfaceDriver
            firewall_driver: nova.virt.firewall.NoopFirewallDriver
            ec2_workers: 4
            osapi_compute_workers: 4
            metadata_workers: 4
            ram_allocation_ratio: 1
            ram_weight_multiplier: -1.0
            use_neutron: True
          conductor:
            workers: 4
          database:
            connection: mysql://nova:{{ pillar['nova_dbpass']}}@{{ pillar['mysqlhost'] }}/nova
          api_database:
            connection: mysql://nova:{{ pillar['nova_dbpass']}}@{{ pillar['mysqlhost'] }}/nova_api
          oslo_messaging_rabbit:
            rabbit_ha_queues: True
            rabbit_hosts: {{ pillar['rabbit_hosts'] }}
            rabbit_userid: openstack
            rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
          keystone_authtoken:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            auth_plugin: password
            project_domain_id: default
            user_domain_id: default
            project_name: service
            username: nova
            password: {{ pillar['nova_pass'] }}
            memcached_servers: {{ pillar['memcached_servers'] }} 
          glance:
            host: {{ pillar['glancepublichost'] }}
            api_servers: https://{{ pillar['glancepublichost'] }}:9292
            protocol: https
          oslo_concurrency:
            lock_path: /var/lock/nova
          neutron:
            url: https://{{ pillar['neutronpublichost'] }}:9696
            auth_type: password
            auth_url: https://jblb.jetstream-cloud.org:35357
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
            novncproxy_base_url: https://jblb.jetstream-cloud.org:6080/vnc_auto.html
            vncserver_listen: 0.0.0.0
            vncserver_proxyclient_address: 127.0.0.1
            xvpvncproxy_base_url: https://jblb.jetstream-cloud.org:6081/console
          cache:
            memcache_servers: {{ pillar['memcached_servers'] }}
