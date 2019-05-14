{% set os_family = salt['grains.get']('os_family', '') %}

cinder_packages:
  pkg.installed: 
    - pkgs: 
      - python2-cinderclient
      - {{ pillar['openstack-cinder'] }}

cleanup_cinderconf:
  cmd.run:
    - require:
      - cinder_packages
    - name: |
        sed -i '/^#/d' /etc/cinder/cinder.conf
        sed -i '/^$/d' /etc/cinder/cinder.conf

include:
  - cinder.cinderconf

{% if pillar['debug-configonly'] == False %}
cinder_services:
  service.running: 
    - name: {{ pillar['openstack-cinder-api'] }}
    - name: {{ pillar['openstack-cinder-volume'] }}
    - name: {{ pillar['openstack-cinder-scheduler'] }}
{% endif %}

      
