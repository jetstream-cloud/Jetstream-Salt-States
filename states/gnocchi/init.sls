gnocchi-user:
  user.present:
    - name: gnocchi
gnocchi-group:
  group.present:
    - name: gnocchi

MySQL-python:
  pkg.installed
python-pip:
  pkg.installed
python-devel:
  pkg.installed
kazoo-eventlet-handler:
  pip.installed:
    - require:
      - pkg: python-pip

librados2-devel:
  pkg.installed
Cython:
  pkg.installed
cradox:
  pip.installed:
    - require:
      - pkg: python-pip

python-memcached:
  pip.installed:
    - require:
      - pkg: python-pip

gnocchi:
  pip.installed:
    - name: gnocchi[mysql,ceph,keystone]

/usr/lib/systemd/system/gnocchi-api.service:
  file.managed:
    - source: salt://gnocchi/gnocchi-api.service

/usr/lib/systemd/system/gnocchi-metricd.service:
  file.managed:
    - source: salt://gnocchi/gnocchi-metricd.service

/etc/gnocchi/gnocchi.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          verbose: True
        api:
          workers: 24
        archive_policy:
          default_aggregation_methods: mean,min,max,sum,std,median,count,95pct
        database:
          connection: mysql://gnocchi:{{ pillar['gnocchi_dbpass'] }}@172.16.128.2/gnocchi?charset=utf8
        indexer:
          url: mysql://gnocchi:{{ pillar['gnocchi_dbpass'] }}@172.16.128.2/gnocchi?charset=utf8
          driver: sqlalchemy
        keystone_authtoken:
          auth_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_type: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: gnocchi
          password: {{ pillar['gnocchi_pass] }}
          memcached_servers: r01c3b16,r02c3b16,r03c3b16
        storage:
          aggregation_workers_number: 24
          coordination_url: zookeeper://jbdb1,jbdb2,jbdb3
          driver: ceph
          ceph_pool: gnocchi
          ceph_username: gnocchi
          ceph_keyring: /etc/ceph/ceph.client.gnocchi.keyring
          ceph_conffile: /etc/ceph/ceph.conf

/etc/gnocchi/api-paste.ini:
  file.managed:
    - source: salt://gnocchi/api-paste.ini

/etc/ceph/ceph.conf:
  file.managed:
    - source: salt://gnocchi/ceph.conf

/etc/ceph/ceph.client.gnocchi.keyring:
  file.managed:
    - source: salt://gnocchi/ceph.client.gnocchi.keyring
    - template: jinja
    - context:
      cephkey-gnocchi: {{ pillar['cephkey-gnocchi'] }}
