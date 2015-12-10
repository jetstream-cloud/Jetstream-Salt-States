{% set os_family = salt['grains.get']('os_family', '') %}

include:
  - cinder.cinderconf

openstack-cinder:
  pkg:
    - name: {{ pillar['openstack-cinder'] }}
    - installed
    - require_in:
      - cmd: openstack-cinder-api
      - ini: /etc/cinder/cinder.conf 
python-cinderclient:
  pkg.installed
python-oslo-db:
  pkg.installed

openstack-cinder-api:
  service:
    - name: {{ pillar['openstack-cinder-api'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/cinder/cinder.conf
    - require:
      - cmd: openstack-cinder-api
  cmd.run:
    - name: su -s /bin/sh -c "cinder-manage db sync" cinder
    - stateful: True

openstack-cinder-volume:
  service:
    - name: {{ pillar['openstack-cinder-volume'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/cinder/cinder.conf
    - require:
      - cmd: openstack-cinder-api

openstack-cinder-scheduler:
{% if os_family=='Debian' %}
  pkg:
    - name: cinder-scheduler
    - installed
{% endif %}
  service:
    - name: {{ pillar['openstack-cinder-scheduler'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/cinder/cinder.conf
    - require:
      - cmd: openstack-cinder-api
      