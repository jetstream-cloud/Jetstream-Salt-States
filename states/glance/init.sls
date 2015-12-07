{% set os_family = salt['grains.get']('os_family', '') %}
      
      
include:
  - glance.glance-apiconf
  - glance.glance-registryconf
  
openstack-glance:
  pkg:
    - name: {{ pillar['openstack-glance'] }}
    - installed
    - required_in:
      - ini: /etc/glance/glance-api.conf
{% if os_family == 'RedHat' %}
python-glance:
  pkg.installed
{% endif %}
python-glanceclient:
  pkg.installed


openstack-glance-api:
  service:
    - name: {{ pillar['openstack-glance-api'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/glance/glance-api.conf
    - require:
      - cmd: openstack-glance-api
  cmd.run:
    - name: su -s /bin/sh -c "glance-manage db_sync" glance
    - stateful: True
    - require:
      - pkg: openstack-glance
      

openstack-glance-registry:
  service:
    - name: {{ pillar['openstack-glance-registry'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/glance/glance-api.conf
    - require:
      - cmd: openstack-glance-api
