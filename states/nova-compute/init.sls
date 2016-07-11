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
          network_api_class: nova.network.neutronv2.api.API
          security_group_api: neutron
          linuxnet_interface_driver: nova.network.linux_net.NeutronLinuxBridgeInterfaceDriver
          firewall_driver: nova.virt.firewall.NoopFirewallDriver
          verbose: True
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.' in item %}
    {% set privateip = item %}
          my_ip: {{ privateip }}
  {% endif %}
{% endfor %}
        vnc:
          enabled: True
          novncproxy_base_url: https://jblb.jetstream-cloud.org:6080/vnc_auto.html
          vncserver_listen:  0.0.0.0
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.' in item %}
    {% set privateip = item %}
          vncserver_proxyclient_address: {{ privateip }}
  {% endif %}
{% endfor %}
          xvpvncproxy_base_url: https://jblb.jetstream-cloud.org:6081/console         
        libvirt:
          live_migration_flag: "VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE,VIR_MIGRATE_TUNNELLED"
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
          host: {{ pillar['glancepublichost'] }}
          protocol: https
        oslo_concurrency:
          lock_path: /var/lock/nova
        neutron:
          url: https://{{ pillar['neutronpublichost'] }}:9696
          auth_strategy: keystone
          auth_type: password
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          project_name: service
          username: neutron
          password: {{ pillar['neutron_pass'] }}

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
        vxlan:
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.' in item %}
    {% set privateip = item %}
          local_ip: {{ privateip }}
  {% endif %}
{% endfor %}
          l2_population: True
          arp_responder: True
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
        ml2_type_gre:
          tunnel_id_ranges: "1:1000"
        ml2_type_vxlan:
          vni_ranges: '100:10000'
          vxlan_group: '239.1.1.1'
        securitygroup:
          enable_security_group: True
          enable_ipset: True
        agent:
          tunnel_types: vxlan
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

nova_qemu_discard_patch:
  file.patch:
{% if os_family == 'RedHat' %}
    - name: /usr/lib/python2.7/site-packages/nova/virt/libvirt/driver.py 
{% elif os_family == 'Debian' %}
    - name: /usr/lib/python2.7/dist-packages/nova/virt/libvirt/driver.py
{% endif %}
    - source: salt://nova-compute/qemu_min_discard.diff
    - hash: md5=d5d259059967cb5f7ba31a6e82194649
    - watch_in:
      - service: openstack-nova-compute

{% if os_family == 'RedHat' %}
/etc/neutron/plugin.ini:
  file.symlink:
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini

/etc/rc.local:
  file.managed:
    - source: salt://nova-compute/rc.local
    - mode: 700
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


