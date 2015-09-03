{% if grains['os_family'] == 'RedHat' %}
openstack-nova-api: openstack-nova-api
openstack-nova-cert: openstack-nova-cert
openstack-nova-conductor: openstack-nova-conductor
openstack-nova-console: openstack-nova-console
openstack-nova-novncproxy: openstack-nova-novncproxy
openstack-nova-scheduler: openstack-nova-scheduler
openstack-nova-console-service: openstack-nova-consoleauth
{% elif grains['os_family'] == 'Debian' %}
openstack-nova-api: nova-api
openstack-nova-cert: nova-cert
openstack-nova-conductor: nova-conductor
openstack-nova-console: nova-consoleauth
openstack-nova-novncproxy: nova-novncproxy
openstack-nova-scheduler: nova-scheduler
openstack-nova-console-service: nova-consoleauth
{% endif %}
