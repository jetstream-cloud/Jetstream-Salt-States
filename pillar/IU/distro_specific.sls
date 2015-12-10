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
{% endif %}
