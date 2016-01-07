{% set os_family = salt['grains.get']('os_family', '') %}

include:
  - iplibpatch

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1
net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0
net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0

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
   - installed:
     - requirein:
       - patch: ip_libpatch 
{% endif %}
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/l3_agent.ini
    - require:
      - patch: ip_libpatch
neutron-dhcp-agent:
{% if os_family=='Debian' %}
  pkg:
   - installed
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
{% endif %}
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/metadata_agent.ini
      
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
          advertise_mtu: True
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

/etc/neutron/plugins/ml2/ml2_conf.ini:
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
          vxlan_group: '239.1.1.1'
        securitygroup:
          enable_security_group: 'True'
          enable_ipset: True
          firewall_driver: neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
        agent:
          tunnel_types: vxlan
        linux_bridge:
          physical_interface_mappings: 'external:bond0.330'
        vxlan:
          l2_population: True
          enable_vxlan: True
          vxlan_group: '239.1.1.1'
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.' in item %}
    {% set privateip = item %}
          local_ip: {{ privateip }}
  {% endif %}
{% endfor %}                             

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
          vxlan_group: '239.1.1.1'
        securitygroup:
          enable_security_group: 'True'
          enable_ipset: True
          firewall_driver: neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
        agent:
          tunnel_types: vxlan
        linux_bridge:
          physical_interface_mappings: 'external:bond0.330'
        vxlan:
          l2_population: True
          enable_vxlan: True
          vxlan_group: '239.1.1.1'
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.' in item %}
    {% set privateip = item %}
          local_ip: {{ privateip }}
  {% endif %}
{% endfor %}                       

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
          dnsmasq_config_file: /etc/neutron/dnsmasq-neutron.conf
          interface_driver: neutron.agent.linux.interface.BridgeInterfaceDriver
          dhcp_driver: neutron.agent.linux.dhcp.Dnsmasq
          dhcp_delete_namespaces: True
          verbose: True
          dnsmasq_dns_servers: 129.79.1.1
          advertise_mtu: True

/etc/neutron/dnsmasq-neutron.conf:
  file.managed:
    - source: salt://neutron-network/dnsmasq-neutron.conf
          
/etc/neutron/metadata_agent.ini:
  ini.options_present:
    - sections:
        DEFAULT:
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
