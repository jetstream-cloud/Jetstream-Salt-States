
{% if grains['os_family'] == 'RedHat' %}
openstack-nova-api: openstack-nova-api
openstack-nova-cert: openstack-nova-cert
openstack-nova-conductor: openstack-nova-conductor
openstack-nova-console: openstack-nova-console
openstack-nova-novncproxy: openstack-nova-novncproxy
openstack-nova-scheduler: openstack-nova-scheduler
openstack-nova-console-service: openstack-nova-consoleauth
openstack-nova-compute: openstack-nova-compute
openstack-neutron: openstack-neutron
openstack-neutron-ml2: openstack-neutron-ml2
openstack-neutron-linuxbridge: openstack-neutron-linuxbridge
openstack-neutron-linuxbridge-service: neutron-linuxbridge-agent
libvirt: libvirt
libvirtd: libvirtd
openstack-glance: openstack-glance
openstack-glance-api: openstack-glance-api
openstack-glance-registry: openstack-glance-registry
openstack-cinder: openstack-cinder
openstack-cinder-api: openstack-cinder-api
openstack-cinder-scheduler: openstack-cinder-scheduler
openstack-cinder-volume: openstack-cinder-volume
python-memcached: python-memcached
openstack-keystone: openstack-keystone
openstack-heat-api:  openstack-heat-api
openstack-heat-api-cfn: openstack-heat-api-cfn
openstack-heat-engine: openstack-heat-engine

# distro_specific

{% elif grains['os_family'] == 'Debian' %}
openstack-nova-api: nova-api
openstack-nova-cert: nova-cert
openstack-nova-conductor: nova-conductor
openstack-nova-console: nova-consoleauth
openstack-nova-novncproxy: nova-novncproxy
openstack-nova-scheduler: nova-scheduler
openstack-nova-console-service: nova-consoleauth
openstack-nova-compute: nova-compute
openstack-neutron: neutron-server
openstack-neutron-ml2: neutron-plugin-ml2
openstack-neutron-linuxbridge: neutron-plugin-linuxbridge-agent
openstack-neutron-linuxbridge-service: neutron-plugin-linuxbridge-agent
libvirt: libvirt-bin
libvirtd: libvirt-bin
openstack-glance: glance
openstack-glance-api: glance-api
openstack-glance-registry: glance-registry
openstack-cinder: cinder-api
openstack-cinder-api: cinder-api
openstack-cinder-scheduler: cinder-scheduler
openstack-cinder-volume: cinder-volume
python-memcached: python-memcache
openstack-keystone: keystone
openstack-heat-engine: heat-engine
openstack-heat-api-cfn: heat-api-cfn
openstack-heat-api: heat-api
{% endif %}

mysqlhost: 172.16.128.2
rabbit_hosts: 172.16.128.253,172.16.128.252,172.16.128.250
keystonehost: jblb.jetstream-cloud.org
keystonepublichost: jblb.jetstream-cloud.org
glancepublichost: jblb.jetstream-cloud.org
glanceprivatehost: jblb.jetstream-cloud.org 
cinderpublichost: jblb.jetstream-cloud.org
cinderprivatehost: jblb.jetstream-cloud.org
novapublichost: jblb.jetstream-cloud.org
novaprivatehost: jblb.jetstream-cloud.org
novametadatahost: 172.16.128.2 
neutronpublichost: jblb.jetstream-cloud.org
neutronprivatehost: jblb.jetstream-cloud.org
ceilometerpublichost: jblb.jetstream-cloud.org
ceilometerprivatehost: jblb.jetstream-cloud.org
gnocchi_url: https://jblb.jetstream-cloud.org:8041
heathost: jblb.jetstream-cloud.org
muranoprivatehost: jblb.jetstream-cloud.org
mistralpublichost: jblb.jetstream-cloud.org
memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211

# todo remove
mcasta_src_ip: 10.10.10.10
mcastb_src_ip: 10.10.10.11

keepalived:
  a_vi_1_state: MASTER
  a_vi_2_state: BACKUP
  a_vi_1_priority: 150
  a_vi_2_priority: 100
  a_mcast_src_ip1: 10.10.10.10
  b_vi_1_state: BACKUP
  b_vi_2_state: MASTER
  b_vi_1_priority: 100
  b_vi_2_priority: 150
  b_mcast_src_ip2: 10.10.10.11


