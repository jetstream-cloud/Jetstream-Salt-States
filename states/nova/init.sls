{% set os_family = salt['grains.get']('os_family', '') %}

nova_packages:
  pkg.installed: 
    - pkgs: 
      - python2-novaclient
      - {{ pillar['openstack-nova-api'] }}
      - {{ pillar['openstack-nova-cert'] }}
      - {{ pillar['openstack-nova-conductor'] }}
      - {{ pillar['openstack-nova-console'] }}
      - {{ pillar['openstack-nova-novncproxy'] }}
      - {{ pillar['openstack-nova-scheduler'] }}
      - {{ pillar['openstack-nova-api'] }}

cleanup_novaconf:
  cmd.run:
    - require: 
      - nova_packages
    - name: |
        sed -i '/^#/d' /etc/nova/nova.conf
        sed -i '/^$/d' /etc/nova/nova.conf

include:
  - nova.novaconf

{% if pillar['debug-configonly'] == False %}
nova_services:
  service.running: 
    - name: {{ pillar['openstack-nova-api'] }}
    - name: {{ pillar['openstack-nova-cert'] }}
    - name: {{ pillar['openstack-nova-conductor'] }}
    - name: {{ pillar['openstack-nova-console'] }}
    - name: {{ pillar['openstack-nova-console-service'] }}
    - name: {{ pillar['openstack-nova-novncproxy'] }}
    - name: {{ pillar['openstack-nova-scheduler'] }}
{% endif %}
