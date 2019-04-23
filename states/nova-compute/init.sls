{% set os_family = salt['grains.get']('os_family', '') %}
{% set rabbit_credential = ['openstack',pillar['openstack_rabbit_pass']]|join(':') %}
{% set rabbit_hosts_list = pillar['rabbit_hosts'].split(',') %}

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

openstack-selinux:
  pkg:
    - installed
    - required_in:
      - service: openstack-neutron-linuxbridge
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
          - notify_on_state_change
          - rpc_backend
          - auth_strategy
          - use_neutron
          - firewall_driver
          - linuxnet_interface_driver
        keystone_authtoken:
          - auth_plugin
        libvirt:
          - live_migration_flag
          - live_migration_uri
        glance:
          - host
          - protocol
          - api_servers
        neutron:
          - auth_strategy
          - url
        placement:
          - os_region_name
        vnc:
          - vncserver_proxyclient_address
          - vncserver_listen
        oslo_messaging_rabbit:
          - rabbit_hosts
          - rabbit_password
          - rabbit_userid

/etc/nova/nova.conf:
  ini.options_present:
    -  sections:
        DEFAULT:
          debug: True
          log_dir: /var/log/nova
          state_path: /var/lib/nova
          compute_driver: libvirt.LibvirtDriver
          compute_monitors: ComputeDriverCPUMonitor,cpu.virt_driver
          instance_usage_audit: True
          instance_usage_audit_period: hour
          notification_driver: messagingv2
          verbose: True
          my_ip: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}
          reserved_host_memory_mb: 3857 
          ram_allocation_ratio: 1
          vif_plugging_is_fatal: False
          scheduler_instance_sync_interval: 300
          update_resources_interval: 300
          transport_url: rabbit://{% for item in rabbit_hosts_list %}{{rabbit_credential}}@{{item}}:5672,{% endfor %}
        api:
          auth_strategy: keystone
        placement:
          region_name: RegionOne
          project_domain_name: Default
          project_name: service
          auth_type: password
          user_domain_name: Default
          auth_url: https://{{ pillar['keystonehost'] }}:35357/v3
          username: placement
          password: {{ pillar['placement_pass'] }}
          timeout: 10
          insecure: True
          endpoint_override: https://internal-lb:8778
        vnc:
          enabled: True
          novncproxy_base_url: https://{{ pillar['novapublichost'] }}:6080/vnc_auto.html
          server_listen:  0.0.0.0
          server_proxyclient_address: {{ salt['grains.get']('ip4_interfaces:bond0:0') }}
          xvpvncproxy_base_url: https://{{ pillar['novapublichost'] }}:6081/console         
        libvirt:
          cpu_mode: host-passthrough
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
          live_migration_scheme: ssh
          live_migration_permit_auto_converge: True
          live_migration_permit_post_copy: True
          transport_url: rabbit://{% for item in rabbit_hosts_list %}{{rabbit_credential}}@{{item}}:5672,{% endfor %}
        workarounds:
          disable_libvirt_livesnapshot: False
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
        keystone_authtoken:
          auth_uri: https://internal-lb:5000
          auth_url: https://internal-lb:35357
          insecure: True
          auth_type: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: nova
          password: {{ pillar['nova_pass'] }}
        cinder:
          endpoint_template: https://internal-lb:8776/v3/%(project_id)s
          insecure: True
        glance:
          insecure: True
          endpoint_override: https://internal-lb:9292
        oslo_concurrency:
          lock_path: /var/lock/nova
        neutron:
          endpoint_override: https://internal-lb:9696
          auth_type: password
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          project_name: service
          username: neutron
          password: {{ pillar['neutron_pass'] }}
          project_domain_name: Default
          user_domain_name:  Default
          region_name: RegionOne
          insecure: True
        notifications:
          notification_format: unversioned
          notify_on_state_change: vm_and_task_state 
/etc/neutron/neutron.conf-absent:
  ini.options_absent:
    - name: /etc/neutron/neutron.conf
    - sections:
        oslo_messaging_rabbit:
          - rabbit_hosts
          - rabbit_userid
          - rabbit_password           
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
          global_physnet_mtu: 9050
          transport_url: rabbit://{% for item in rabbit_hosts_list %}{{rabbit_credential}}@{{item}}:5672,{% endfor %}
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
        
/etc/neutron/plugins/ml2/linuxbridge_agent.ini:
  ini.options_present:
    - sections:
        linux_bridge:
          physical_interface_mappings: "public:bond0.330,iris-wrangler:bond0.360,unidata-wrangler:bond0.361,sra-wrangler:bond0.362,tg-cie160046-wrangler:bond0.363,tg-cie160051-wrangler:bond0.364,jettest-wrangler:bond0.365,seagrid-wrangler:bond0.366,geode2-test:bond0.302,unavco-wrangler:bond0.367,asc-wrangler:bond0.368,nfss-wrangler:bond0.369,vast-demo:bond0.370,red:bond0.371"
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
          mechanism_drivers: linuxbridge
          physical_network_mtus: "public:9000,iris-wrangler:9000,unidata-wrangler:9000,sra-wrangler:9000,tg-cie160046-wrangler:9000,tg-cie160051-wrangler:9000,jettest-wrangler:9000,seagrid-wrangler:9000,geode2-test:9000,unavco-wrangler:9000,asc-wrangler:9000,nfss-wrangler:9000,vast-demo:9000,red:9000"
          path_mtu: 9050
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
python2-ceilometerclient:
  pkg.installed

/etc/ceilometer/ceilometer.conf:
  ini.options_present:
    -  sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          verbose: True
          host: {{ grains['host'] }}
          transport_url: rabbit://{% for item in rabbit_hosts_list %}{{rabbit_credential}}@{{item}}:5672,{% endfor %}
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
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


