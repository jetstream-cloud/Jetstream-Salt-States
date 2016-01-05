/etc/nova/nova.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          my_ip: {{ pillar['novaprivatehost'] }}
          vncserver_listen: {{ pillar['novaprivatehost'] }}
          vncserver_proxyclient_address: {{ pillar['novaprivatehost'] }}
          verbose: True
          network_api_class: nova.network.neutronv2.api.API
          security_group_api: neutron
          linuxnet_interface_driver: nova.network.linux_net.LinuxBridgeInterfaceDriver
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
        database:
          connection: mysql://nova:{{ pillar['nova_dbpass']}}@{{ pillar['mysqlhost'] }}/nova
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
        glance:
          host: {{ pillar['glanceprivatehost'] }}
        oslo_concurrency:
          lock_path: /var/lock/nova
        neutron:
          url: https://{{ pillar['neutronpublichost'] }}:9696
          auth_strategy: keystone
          admin_auth_url: https://{{ pillar['keystonehost'] }}:35357/v2.0
          admin_tenant_name: service
          admin_username: neutron
          admin_password: {{ pillar['neutron_pass'] }}
          metadata_proxy_shared_secret: {{ pillar['metadata_proxy_shared_secret'] }}
          service_metadata_proxy: True
