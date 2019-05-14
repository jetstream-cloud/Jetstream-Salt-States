{% set os_family = salt['grains.get']('os_family', '') %}

glance_packages:
  pkg.installed:
    - pkgs:
      - python2-glanceclient
      - {{ pillar['openstack-glance'] }}

cleanup_glanceconf:
  cmd.run:
    - require:
      - glance_packages
    - name: |
        sed -i '/^#/d' /etc/glance/glance-api.conf
        sed -i '/^$/d' /etc/glance/glance-api.conf
        sed -i '/^#/d' /etc/glance/glance-registry.conf
        sed -i '/^$/d' /etc/glance/glance-registry.conf

include:
  - glance.glance-apiconf
  - glance.glance-registryconf
  
{% if pillar['debug-configonly'] == False %}
glance_services:
  service.running:
    - {{ pillar['openstack-glance-api'] }}
    - {{ pillar['openstack-glance-registry'] }}
{% endif %}
