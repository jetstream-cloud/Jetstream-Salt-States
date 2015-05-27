/etc/nova/nova.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          my_ip: 172.16.128.2
          vncserver_listen: 172.16.128.2
          vncserver_proxyclient_address: 172.16.128.2
          verbose: True
          network_api_class: nova.network.neutronv2.api.API
          security_group_api: neutron
          linuxnet_interface_driver: nova.network.linux_net.LinuxBridgeInterfaceDriver
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
        database:
          connection: mysql://nova:{{ pillar['nova_dbpass']}}@172.16.128.2/nova
        oslo_messaging_rabbit:
          rabbit_host: 172.16.128.2
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        keystone_authtoken:
          auth_uri: http://172.16.128.2:5000
          auth_url: http://172.16.128.2:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: nova
          password: {{ pillar['nova_pass'] }}
        glance:
          host: 172.16.128.2
        oslo_concurrency:
          lock_path: /var/lock/nova
        neutron:
          url: http://172.16.128.2:9696
          auth_strategy: keystone
          admin_auth_url: http://172.16.128.2:35357/v2.0
          admin_tenant_name: service
          admin_username: neutron
          admin_password: {{ pillar['neutron_pass'] }}
          metadata_proxy_shared_secret: {{ pillar['metadata_proxy_shared_secret'] }}
          service_metadata_proxy: True