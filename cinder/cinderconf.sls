/etc/cinder/cinder.conf:
  ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          verbose: True
          my_ip: {{ pillar['cinderprivatehost'] }}
          volume_driver: cinder.volume.drivers.rbd.RBDDriver
          rbd_user = cinder
          rbd_secret_uuid: {{ pillar['libvirt_secret_uuid'] }} 
          rbd_pool: volumes
          rbd_ceph_conf: /etc/ceph/ceph.conf
          rbd_flatten_volume_from_snapshot: false
          rbd_max_clone_depth: 5
          rbd_store_chunk_size: 4
          rados_connect_timeout: -1
          glance_api_version: 2
          backup_driver: cinder.backup.drivers.ceph
          backup_ceph_conf: /etc/ceph/ceph.conf
          backup_ceph_user: cinder-backup
          backup_ceph_chunk_size: 134217728
          backup_ceph_pool: backups
          backup_ceph_stripe_unit: 0
          backup_ceph_stripe_count: 0
          restore_discard_excess_bytes: true
        database:
          connection: mysql://cinder:{{ pillar['cinder_dbpass'] }}@{{ pillar['mysqlhost'] }}/cinder
        keystone_authtoken:
          auth_uri: http://{{ pillar['keystonehost'] }}:5000
          auth_url: http://{{ pillar['keystonehost'] }}:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: cinder
          password: {{ pillar['cinder_pass'] }}
        oslo_messaging_rabbit:
          rabbit_host: {{ pillar['rabbit_controller'] }}
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        oslo_concurrency:
          lock_path: /var/lock/cinder
  file.managed:
    - user: cinder
    - group: cinder
