{% set os_family = salt['grains.get']('os_family', '') %}

openstack-nova-api:
  pkg:
    - name: {{ pillar['openstack-nova-api'] }}
    - installed
    - require_in:
      - cmd: openstack-nova-api
      - ini: /etc/nova/nova.conf
  service:
    - name: {{ pillar['openstack-nova-api'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
  cmd.run:
    - name: su -s /bin/sh -c "nova-manage db sync" nova
    - stateful: True
openstack-nova-cert:
  pkg:
    - name: {{ pillar['openstack-nova-cert'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-cert'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-cert
      - service: openstack-nova-api
openstack-nova-conductor:
  pkg:
    - name: {{ pillar['openstack-nova-conductor'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-conductor'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-conductor
      - service: openstack-nova-api
openstack-nova-console:
  pkg:
    - name: {{ pillar['openstack-nova-console'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-console-service'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-console
      - service: openstack-nova-api
openstack-nova-novncproxy:
  pkg:
    - name: {{ pillar['openstack-nova-novncproxy'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-novncproxy'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-novncproxy
      - service: openstack-nova-api
openstack-nova-scheduler:
  pkg:
    - name: {{ pillar['openstack-nova-scheduler'] }}
    - installed
  service:
    - name: {{ pillar['openstack-nova-scheduler'] }}
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
    - require:
      - pkg: openstack-nova-scheduler
      - service: openstack-nova-api
python-novaclient:
  pkg.installed

/var/lock/nova:
  file.directory:
    - user: nova
    - group: nova

    

include:
  - nova.novaconf
