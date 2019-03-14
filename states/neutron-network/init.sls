{% set os_family = salt['grains.get']('os_family', '') %}
{% set rabbit_credential = ['openstack',pillar['openstack_rabbit_pass']]|join(':') %}
{% set rabbit_hosts_list = pillar['rabbit_hosts'].split(',') %}

# this has been fixed
#include:
#  - iplibpatch

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1
net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0
net.ipv6.conf.default.forwarding:
  sysctl.present:
    - value: 1
net.ipv6.conf.all.forwarding:
  sysctl.present:
    - value: 1
net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0
net.ipv4.neigh.default.gc_thresh1:
  sysctl.present:
    - value: 10240
net.ipv4.neigh.default.gc_thresh2: 
  sysctl.present:
    - value: 40960
net.ipv4.neigh.default.gc_thresh3:
  sysctl.present:
    - value: 81920
net.ipv4.igmp_max_memberships:
  sysctl.present:
    - value: 200

{% if os_family=='RedHat' %}
openstack-neutron:
  pkg:
    - installed
    - require_in:
      - ini: /etc/neutron/neutron.conf
{% endif %}
openstack-neutron-ml2:
  pkg:
    - name: {{ pillar['openstack-neutron-ml2'] }}
    - installed
    - require_in:
      - ini: /etc/neutron/plugins/ml2/ml2_conf.ini
openstack-neutron-linuxbridge:
  pkg:
    - name: {{ pillar['openstack-neutron-linuxbridge'] }}
    - installed
    - require_in:
      - service: openstack-neutron-linuxbridge
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/plugins/ml2/linuxbridge_agent.ini 
  service:
    - name: {{ pillar['openstack-neutron-linuxbridge-service'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/plugins/ml2/ml2_conf.ini
neutron-l3-agent:
{% if os_family=='Debian' %}
  pkg:
   - installed
   - require_in:
     - ini: /etc/neutron/l3_agent.ini
     - ini: /etc/neutron/neutron.conf
{% endif %}
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/l3_agent.ini
neutron-dhcp-agent:
{% if os_family=='Debian' %}
  pkg:
   - installed
   - require_in:
     - ini: /etc/neutron/dhcp_agent.ini
     - ini: /etc/neutron/neutron.conf
{% endif %}
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/dhcp_agent.ini
neutron-metadata-agent:
{% if os_family=='Debian' %}
  pkg:
   - installed
   - require_in:
     - ini: /etc/neutron/metadata_agent.ini
     - ini: /etc/neutron/neutron.conf
{% endif %}
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/metadata_agent.ini
neutron-lbaas-agent:
  pkg:
    - installed
{% if os_family=='RedHat' %}
    - name: openstack-neutron-lbaas
{% endif %}
    - require_in:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/lbaas_agent.ini
  service:
    - name: neutron-lbaasv2-agent
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/lbaas_agent.ini 

neutron-vpn-agent:
  pkg:
    - installed
{% if os_family=='RedHat' %}
    - name: openstack-neutron-vpnaas
{% endif %}
    - require_in:
      - ini: /etc/neutron/neutron.conf
  service:
    - dead
    - enable: False 
    - watch:
      - ini: /etc/neutron/neutron.conf
strongswan:
  pkg.installed
      
/etc/neutron/neutron.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          core_plugin: ml2
          service_plugins: router
          allow_overlapping_ips: True
          verbose: True
          network_device_mtu: 9000
          global_physnet_mtu: 9050
          advertise_mtu: True
          dhcp_lease_duration: 300
        keystone_authtoken:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: neutron
          password: {{ pillar['neutron_pass'] }}
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{pillar['openstack_rabbit_pass'] }}
        service_providers:
          service_provider: "LOADBALANCERV2:Haproxy:neutron_lbaas.drivers.haproxy.plugin_driver.HaproxyOnHostPluginDriver:default"

/etc/neutron/lbaas_agent.ini:
  ini.options_present:
    - sections:
        DEFAULT:
          interface_driver: linuxbridge
          device_driver: neutron_lbaas.drivers.haproxy.namespace_driver.HaproxyNSDriver 

/etc/neutron/plugins/ml2/ml2_conf.ini:
  ini.options_present:
    - sections:
        ml2:
          type_drivers: flat,vxlan
          tenant_network_types: vxlan
          mechanism_drivers: linuxbridge,l2population
          path_mtu: 9050
          physical_network_mtus: "public:9000,iris-wrangler:9000,unidata-wrangler:9000,sra-wrangler:9000,tg-cie160046-wrangler:9000,tg-cie160051:9000,jettest-wrangler:9000,seagrid-wrangler:9000,unavco-wrangler:9000,asc-wrangler:9000,vast-demo:9000,geode2-test:9000,nfss-wrangler:9000,red:9000"
        ml2_type_gre:
          tunnel_id_ranges: '1:1000'
        ml2_type_vxlan:
          vni_ranges: '100:10000'
          vxlan_group: '239.0.0.0/25'
        securitygroup:
          enable_security_group: 'True'
          enable_ipset: True
          firewall_driver: neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
        agent:
          tunnel_types: vxlan
        linux_bridge:
          physical_interface_mappings: 'geode2-test:bond0.302,public:bond0.330,iris-wrangler:bond0.360,unidata-wrangler:bond0.361,sra-wrangler:bond0.362,tg-cie160046-wrangler:bond0.363,tg-cie160051:bond0.364,jettest-wrangler:bond0.365,seagrid-wrangler:bond0.366,unavco-wrangler:bond0.367,asc-wrangler:bond0.368,nfss-wrangler:bond0.369,vast-demo:bond0.370,red:bond0.371'
        vxlan:
          l2_population: {{ pillar['unicast_vxlan'] }} 
          enable_vxlan: True
          vxlan_group: '239.0.0.0/25'
          local_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}
                      

/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  ini.options_present:
    - sections:
        ml2:
          type_drivers: flat,vlan,gre,vxlan
          tenant_network_types: vxlan
          mechanism_drivers: linuxbridge,l2population
        ml2_type_gre:
          tunnel_id_ranges: '1:1000'
        ml2_type_vxlan:
          vni_ranges: '100:10000'
          vxlan_group: 'vxlan_group = 239.0.0.0/25'
        securitygroup:
          enable_security_group: 'True'
          enable_ipset: True
          firewall_driver: neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
        agent:
          tunnel_types: vxlan
        linux_bridge:
          physical_interface_mappings: 'public:bond0.330,iris-wrangler:bond0.360,unidata-wrangler:bond0.361,sra-wrangler:bond0.362,tg-cie160046-wrangler:bond0.363,tg-cie160051-wrangler:bond0.364,jettest-wrangler:bond0.365,seagrid-wrangler:bond0.366,unavco-wrangler:bond0.367,asc-wrangler:bond0.368,nfss-wrangler:bond0.369,vast-demo:bond0.370,red:bond0.371'
        vxlan:
          arp_responder: {{ pillar['unicast_vxlan'] }}
          l2_population: {{ pillar['unicast_vxlan'] }} 
          enable_vxlan: True
          vxlan_group: '239.0.0.0/25'
          local_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}
            

/etc/neutron/l3_agent.ini:
  ini.options_present:
    - sections:
        DEFAULT:
          interface_driver: neutron.agent.linux.interface.BridgeInterfaceDriver
          external_network_bridge: ""
          router_delete_namespaces: True
          
/etc/neutron/dhcp_agent.ini:
  ini.options_present:
    - sections:
        DEFAULT:
          agent_mode: legacy
          router_delete_namespaces: True
          use_namespaces: True
          dnsmasq_config_file: /etc/neutron/dnsmasq-neutron.conf
          interface_driver: linuxbridge
          dhcp_driver: neutron.agent.linux.dhcp.Dnsmasq
          dhcp_delete_namespaces: True
          verbose: True
          dnsmasq_dns_servers: 129.79.1.1,129.79.5.100,129.79.8.50
          dhcp_domain: jetstreamlocal
          advertise_mtu: True

/etc/neutron/dnsmasq-neutron.conf:
  file.managed:
    - source: salt://neutron-network/dnsmasq-neutron.conf
          
/etc/neutron/metadata_agent.ini:
  ini.options_present:
    - sections:
        DEFAULT:
          nova_metadata_insecure: True
          nova_metadata_protocol: https
          nova_metadata_ip: {{ pillar['novametadatahost'] }}
          metadata_proxy_shared_secret: {{ pillar['metadata_proxy_shared_secret'] }}
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_region: RegionOne
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: neutron
          password: {{ pillar['neutron_pass'] }}

/etc/cron.daily/restart_linuxbridge-agent.cron:
  file.managed:
    - source: salt://neutron-network/restart_linuxbridge-agent.cron
    - mode: 744
