{% set os_family = salt['grains.get']('os_family', '') %}

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0
net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0
net.bridge.bridge-nf-call-iptables:
  sysctl.present:
    - value: 1
net.bridge.bridge-nf-call-ip6tables:
  sysctl.present:
    - value: 1

openstack-nova-compute:
  pkg:
{% if os_family == 'Debian' %}
    - name: nova-compute
{% endif %}  
    - installed
    - required_in:
      - ini: /etc/nova/nova.conf
  service:
{% if os_family == 'Debian' %}
    - name: nova-compute
{% endif %}  
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - service: libvirtd
{% if os_family == 'RedHat' %}
openstack-neutron:
   - installed
   - require_in:
     - ini: /etc/neutron/neutron.conf
openstack-neutron-ml2:
  pkg:
   - installed
   - require_in:
     - ini: /etc/neutron/plugins/ml2/ml2_conf.ini
{% endif %}
openstack-neutron-linuxbridge:
  pkg:
{% if os_family == 'Debian' %}
   - name: neutron-plugin-linuxbridge-agent
{% endif %}  
   - installed
   - require_in:
     - ini: /etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini
sysfsutils:
  pkg:
    - installed
libvirt:
  pkg:
{% if os_family == 'Debian' %}
    - name: libvirt-bin
{% endif %}  
    - installed
  
libvirtd:
  service:
{% if os_family == 'Debian' %}
    - name: libvirt-bin
{% endif %}  
    - running
    - enable: True
    - require:
      - pkg: libvirt

neutron-linuxbridge-agent:
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/neutron/neutron.conf
      - ini: /etc/neutron/plugins/ml2/ml2_conf.ini
      - ini: /etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini
include:
  - nova-compute.ceph

/root/secret.xml:
  file.managed:
    - source: salt://nova-compute/secret.xml
    - mode: 600

virsh secret-define /root/secret.xml:
  cmd.run:
    - unless: virsh secret-list |grep {{ pillar['libvirt_secret_uuid'] }}
    - require:
      - file: /root/secret.xml
      - service: libvirtd
    - require_in:
      - cmd: setsecret

setsecret:
  cmd.run:
    - name: virsh secret-set-value --secret {{ pillar['libvirt_secret_uuid'] }} --base64 {{ pillar['cephclientcinderkey'] }}
    - onlyif: virsh secret-list |grep {{ pillar['libvirt_secret_uuid'] }}
    - unless: virsh secret-get-value --secret {{ pillar['libvirt_secret_uuid'] }}
  require:
    - file: /root/secret.xml
    - service: libvirtd
  
/etc/nova/nova.conf:
  ini.options_present:
    -  sections:
        DEFAULT:
          debug: True
          rpc_backend: rabbit
          auth_strategy: keystone
          vnc_enabled: True
          vncserver_listen: 0.0.0.0
          vncserver_proxyclient_address: {{ pillar['novaprivatehost'] }}
          novncproxy_base_url: http://{{ pillar['novaprivatehost'] }}:6080/vnc_auto.html
          network_api_class: nova.network.neutronv2.api.API
          security_group_api: neutron
          linuxnet_interface_driver: nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
          verbose: True
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.128' in item %}
    {% set privateip = item %}
          my_ip: {{ privateip }}
  {% endif %}
{% endfor %}          
        libvirt:
          live_migration_flag: "VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE,VIR_MIGRATE_PERSIST_DEST"
          inject_password: false
          inject_key: false
          inject_partition: -2
          images_type: rbd
          images_rbd_pool: vms
          images_rbd_ceph_conf: /etc/ceph/ceph.conf
          rbd_user: cinder
          rbd_secret_uuid: {{ pillar['libvirt_secret_uuid'] }}
          disk_cachemodes: "network=writeback"
        oslo_messaging_rabbit:
          rabbit_host: {{ pillar['rabbit_controller'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        keystone_authtoken:
          auth_uri: http://{{ pillar['keystonehost'] }}:5000
          auth_url: http://{{ pillar['keystonehost'] }}:35357
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
          url: http://{{ pillar['neutronprivatehost'] }}:9696
          auth_strategy: keystone
          admin_auth_url: http://{{ pillar['keystonehost'] }}:35357/v2.0
          admin_tenant_name: service
          admin_username: neutron
          admin_password: {{ pillar['neutron_pass'] }}

/etc/neutron/neutron.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          debug: True
          rpc_backend: rabbit
          auth_strategy: keystone
          core_plugin: ml2
          service_plugins: router
          allow_overlapping_ips: True
          notify_nova_on_port_status_changes: True
          notify_nova_on_port_data_changes: True
          nova_url: http://{{ pillar['novaprivatehost'] }}:8774/v2
          verbose: True
          network_device_mtu: 8950
        nova:
          auth_url: http://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          region_name: RegionOne
          project_name: service
          username: nova
          password: {{ pillar['nova_pass'] }}
        keystone_authtoken:
          auth_uri: http://{{ pillar['keystonehost'] }}:5000
          auth_url: http://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: neutron
          password: {{ pillar['neutron_pass'] }}
        oslo_messaging_rabbit:
          rabbit_host: {{ pillar['rabbit_controller'] }}
          rabbit_userid: openstack
          rabbit_password: {{pillar['openstack_rabbit_pass'] }}
        
/etc/neutron/plugins/ml2/ml2_conf.ini:
  ini.options_present:
    - sections:
        ml2:
          type_drivers: flat,vlan,gre,vxlan
          tenant_network_types: vxlan,vlan
          mechanism_drivers: linuxbridge
        ml2_type_gre:
          tunnel_id_ranges: "1:1000"
        ml2_type_vxlan:
          vni_ranges: '100:1000'
          vxlan_group: '239.1.1.1'
        securitygroup:
          enable_security_group: True
          enable_ipset: True
        agent:
          tunnel_types: vxlan
/etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini:
  ini.options_present:
    - sections:
        vxlan:
          enable_vxlan: True
          vxlan_group: '239.1.1.1'
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.128' in item %}
    {% set privateip = item %}
          local_ip: {{ privateip }}
  {% endif %}
{% endfor %}         

{% if os_family == 'RedHat' %}
/etc/neutron/plugin.ini:
  file.symlink:
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini
{% endif %}             
