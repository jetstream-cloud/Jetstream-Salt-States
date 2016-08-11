{% set os_family = salt['grains.get']('os_family', '') %}
      
openstack-neutron:
  pkg:
    - name: {{ pillar['openstack-neutron'] }}
    - installed
    - require-in:
      - ini: /etc/neutron/neutron.conf
  service:
    - name: neutron-server
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
    - require:
      - cmd: openstack-neutron
  cmd.run:
    - name: su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron 2>&1|grep -q OK
    - stateful: True
    - require:
      - ini: /etc/neutron/plugins/ml2/ml2_conf.ini
      - ini: /etc/neutron/neutron.conf

openstack-neutron-ml2:
  pkg:
    - name: {{ pillar['openstack-neutron-ml2'] }}
    - installed
python-neutronclient:
  pkg.installed
openstack-neutron-vpnaas:
  pkg.installed
openstack-neutron-lbaas:
  pkg.installed

{% if os_family == 'RedHat' %}
/etc/neutron/plugin.ini:
  file.symlink:
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini
{% endif %}    

/etc/neutron/neutron.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          api_workers: 4
          rpc_backend: rabbit
          auth_strategy: keystone
          core_plugin: ml2
          service_plugins: router,neutron_lbaas.services.loadbalancer.plugin.LoadBalancerPlugin,neutron_vpnaas.services.vpn.plugin.VPNPlugin
          allow_overlapping_ips: True
          router_distributed: False
          notify_nova_on_port_status_changes: True
          notify_nova_on_port_data_changes: True
          nova_url: https://{{ pillar['novapublichost'] }}:8774/v2
          verbose: True
          global_physnet_mtu: 9050
          network_device_mtu: 9000 
          advertise_mtu: True
          dhcp_agents_per_network: 2
          allow_automatic_l3agent_failover: True
          max_l3_agents_per_router: 3
          min_l3_agents_per_router: 2
          l3_ha: True
          l3_ha_net_cidr: 169.254.192.0/18
        nova:
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          region_name: RegionOne
          project_name: service
          username: nova
          password: {{ pillar['nova_pass'] }}
        keystone_authtoken:
          memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211
          token_cache_time: 3600
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          user-name: neutron
          password: {{ pillar['neutron_pass'] }}
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{pillar['openstack_rabbit_pass'] }}
        database:
          connection: mysql://neutron:{{ pillar['neutron_dbpass'] }}@{{ pillar['mysqlhost'] }}/neutron
        service_providers:
          service_provider: "LOADBALANCER:Haproxy:neutron_lbaas.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default"
          service_provider: "VPN:openswan:neutron_vpnaas.service.vpn.service_drivers.ipsec.IPsecVPNDriver.default"
/etc/neutron/plugins/ml2/ml2_conf.ini:
  ini.options_present:
    - sections:
        ml2:
          type_drivers: flat,vlan,gre,vxlan
          tenant_network_types: vxlan,vlan
          mechanism_drivers: linuxbridge,l2population
        ml2_type_gre:
          tunnel_id_ranges: '1:1000'
        ml2_type_vxlan:
          vni_ranges: '100:10000'
          vxlan_group: '239.1.1.1'
        securitygroup:
          enable_security_group: 'True'
          enable_ipset: True
          firewall_driver: neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
