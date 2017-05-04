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
net.ipv4.igmp_max_memberships:
  sysctl.present:
    - value: 200

firewalld:
  service:
    - enable: False
    - dead

openstack-nova-compute:
  pkg:
    - name: {{ pillar['openstack-nova-compute'] }}
    - installed
    - required_in:
      - ini: /etc/nova/nova.conf
  service:
    - name: {{ pillar['openstack-nova-compute'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - service: libvirtd
{% if os_family == 'RedHat' %}
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
sysfsutils:
  pkg:
    - installed
libvirt:
  pkg:
    - name: {{ pillar['libvirt'] }}
    - installed
  
libvirtd:
  service:
    - name: {{ pillar['libvirtd'] }}
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
      - ini: /etc/neutron/plugins/ml2/linuxbridge_agent.ini
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
    - name: virsh secret-set-value --secret {{ pillar['libvirt_secret_uuid'] }} --base64 {{ pillar['cephkey-cinder'] }}
    - onlyif: virsh secret-list |grep {{ pillar['libvirt_secret_uuid'] }}
    - unless: virsh secret-get-value --secret {{ pillar['libvirt_secret_uuid'] }}
  require:
    - file: /root/secret.xml
    - service: libvirtd

/etc/nova/nova.conf-absent:
  ini.options_absent:
    - name: /etc/nova/nova.conf
    - sections:
        DEFAULT:
          - network_api_class
          - security_group_api
          - 
        libvirt:
          - live_migration_flag
        glance:
          - host
          - protocol
        neutron:
          - auth_strategy
/etc/nova/nova.conf:
  ini.options_present:
    -  sections:
        DEFAULT:
          debug: True
          log_dir: /var/log/nova
          state_path: /var/lib/nova
          compute_driver: libvirt.LibvirtDriver
          compute_monitors: ComputeDriverCPUMonitor,cpu.virt_driver
          rpc_backend: rabbit
          auth_strategy: keystone
          instance_usage_audit: True
          instance_usage_audit_period: hour
          notify_on_state_change: vm_and_task_state
          notification_driver: messagingv2
          linuxnet_interface_driver: nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
          verbose: True
          use_neutron: True
          my_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}

        vnc:
          enabled: True
          novncproxy_base_url: https://{{ pillar['novapublichost'] }}:6080/vnc_auto.html
          vncserver_listen:  0.0.0.0
          vncserver_proxyclient_address: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}
          xvpvncproxy_base_url: https://{{ pillar['novapublichost'] }}:6081/console         
        libvirt:
          cpu_mode: host-passthrough
          live_migration_uri: qemu+ssh://%s/system
          inject_password: false
          inject_key: false
          inject_partition: -2
          images_type: rbd
          images_rbd_pool: ephemeral-vms
          images_rbd_ceph_conf: /etc/ceph/ceph.conf
          rbd_user: cinder
          rbd_secret_uuid: {{ pillar['libvirt_secret_uuid'] }}
          disk_cachemodes: "network=writeback"
          hw_disk_discard: unmap
          volume_clear: none
          live_migration_permit_auto_converge: True
          live_migration_permit_post_copy: True
        workarounds:
          disable_libvirt_livesnapshot: False
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
          api_servers: https://{{ pillar['glancepublichost'] }}:9292
        oslo_concurrency:
          lock_path: /var/lock/nova
        neutron:
          url: https://{{ pillar['neutronpublichost'] }}:9696
          auth_type: password
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          project_name: service
          username: neutron
          password: {{ pillar['neutron_pass'] }}
          project_domain_name: Default
          user_domain_name:  Default
          region_name: RegionOne
           
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
          nova_url: https://{{ pillar['novapublichost'] }}:8774/v2
          verbose: True
          network_device_mtu: 9000 
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
        
/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  ini.options_present:
    - sections:
        linux_bridge:
          physical_interface_mappings: "iris-wrangler:bond0.360,unidata-wrangler:bond0.361,sra-wrangler:bond0.362"
        vxlan:

          local_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}
          vxlan_group: 239.0.0.0/25
          l2_population: {{ pillar['unicast_vxlan'] }} 
          arp_responder: {{ pillar['unicast_vxlan'] }}
        securitygroup:
          firewall_driver: neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
          enable_security_group: True

/etc/neutron/plugins/ml2/ml2_conf.ini:
  ini.options_present:
    - sections:
        ml2:
          type_drivers: flat,vlan,gre,vxlan
          tenant_network_types: vxlan,vlan
          mechanism_drivers: linuxbridge,l2population
          physical_network_mtus: "iris-wrangler:9000,unidata-wrangler:9000,sra-wrangler:9000"
        ml2_type_gre:
          tunnel_id_ranges: "1:1000"
        ml2_type_vxlan:
          vni_ranges: '100:10000'
          vxlan_group: '239.0.0.0/25'
        securitygroup:
          enable_security_group: True
          enable_ipset: True
        agent:
          tunnel_types: vxlan
        vxlan:
          l2_population: {{ pillar['unicast_vxlan'] }} 
          enable_vxlan: True
          vxlan_group: '239.0.0.0/25'

          local_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}


{% if os_family == 'RedHat' %}
/etc/neutron/plugin.ini:
  file.symlink:
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini

/etc/rc.local:
  file.managed:
    - source: salt://nova-compute/rc.local
    - mode: 700
    - owner: root

/etc/modules.d:
  file.directory

/etc/modprobe.d/kvm-intel.conf:
  file.managed:
    - source: salt://nova-compute/kvm-intel.conf
    - mode: 644
    - owner: root

python-devel:
  pkg.installed
libffi-devel:
  pkg.installed
openssl-devel:
  pkg.installed
{% endif %}
openstack-ceilometer-compute:
  pkg:
    - installed
    - require_in:
      - ini: /etc/ceilometer/ceilometer.conf
  service:
    - enable: True
    - running
    - watch:
      - ini: /etc/ceilometer/ceilometer.conf
python-ceilometerclient:
  pkg.installed

/etc/ceilometer/ceilometer.conf:
  ini.options_present:
    -  sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          verbose: True
          host: {{ grains['host'] }}
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
          rabbit_hosts: {{ pillar['rabbit_hosts'] }}
          rabbit_userid: openstack
          rabbit_password: {{pillar['openstack_rabbit_pass'] }}
        keystone_authtoken:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: ceilometer
          password: {{ pillar['ceilometer_pass'] }}
        service_credentials:
          os_auth_url: https://{{ pillar['keystonehost'] }}:5000/v2.0
          os_username: ceilometer
          os_tenant_name: service
          os_password: {{ pillar['ceilometer_pass'] }}
          os_endpoint_typeL: publicURL
          os_region_name: RegionOne


