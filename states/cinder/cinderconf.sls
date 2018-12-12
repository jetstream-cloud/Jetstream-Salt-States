{% set rabbit_credential = ['openstack',pillar['openstack_rabbit_pass']]|join(':') %}
{% set rabbit_hosts_list = pillar['rabbit_hosts'].split(',') %}

/etc/cinder/cinder.conf-deprecated:
  ini.options_absent:
    - name: /etc/cinder/cinder.conf
    - sections:
        DEFAULT:
          - rpc_backend
          - notification_driver
        keystone_authtoken:
          - auth_plugin
          - auth_uri
        oslo_messaging_rabbit:
          - rabbit_hosts
          - rabbit_password
          - rabbit_userid
/etc/cinder/cinder.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          auth_strategy: keystone
          verbose: True
          my_ip: {{ pillar['cinderprivatehost'] }}
          enabled_backends: ceph
          backup_driver: cinder.backup.drivers.ceph
          backup_ceph_conf: /etc/ceph/ceph.conf
          backup_ceph_user: cinder-backup
          backup_ceph_chunk_size: 134217728
          backup_ceph_pool: cinder-backups
          backup_ceph_stripe_unit: 0
          backup_ceph_stripe_count: 0
          restore_discard_excess_bytes: true
          osapi_volume_workers: 4
          report_discard_supported:  true
          allow_availability_zone_fallback: True
          transport_url: rabbit://{% for item in rabbit_hosts_list %}{{rabbit_credential}}@{{item}}:5672,{% endfor %}
          enable_v3_api: True
          enable_v2_api: False
        ceph:
          volume_backend_name: ceph
          volume_driver: cinder.volume.drivers.rbd.RBDDriver
          rbd_user: cinder
          rbd_secret_uuid: {{ pillar['libvirt_secret_uuid'] }}
          rbd_pool: cinder-volumes
          rbd_ceph_conf: /etc/ceph/ceph.conf
          rbd_flatten_volume_from_snapshot: false
          rbd_max_clone_depth: 5
          rbd_store_chunk_size: 4
          rados_connect_timeout: -1
          glance_api_version: 2
          report_discard_supported: True
        database:
          connection: mysql+pymysql://cinder:{{ pillar['cinder_dbpass'] }}@{{ pillar['mysqlhost'] }}/cinder
        keystone_authtoken:
          memcached_servers: {{ pillar['memcached_servers'] }}
          www_authenticate_uri: https://{{ pillar['keystonehost'] }}:5000
          auth_url: https://{{ pillar['keystonehost'] }}:35357
          auth_type: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: cinder
          password: {{ pillar['cinder_pass'] }}
        oslo_messaging_rabbit:
          rabbit_ha_queues: True
        oslo_concurrency:
          lock_path: /var/lock/cinder
        oslo_messaging_notifications:
            driver: messagingv2
  file.managed:
    - user: cinder
    - group: cinder
