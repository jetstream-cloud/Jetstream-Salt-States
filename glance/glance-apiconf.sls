/etc/glance/glance-api.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            test: test
            default_store: rbd
            known_stores: glance.store.rbd.Store
            bind_host: 0.0.0.0
            bind_port: 9292
            log_file: /var/log/glance/api.log
            backlog: 4096
            workers: 1
            show_image_direct_url: True
            registry_host: 0.0.0.0
            registry_port: 9191
            registry_client_protocol: http
            notification_driver: messaging
            rpc_backend: rabbit
            rabbit_host: {{ pillar['rabbit_controller'] }}
            rabbit_port: 5672
            rabbit_use_ssl: false
            rabbit_userid: guest
            rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
            rabbit_virtual_host: /
            rabbit_notification_exchange: glance
            rabbit_notification_topic: notifications
            rabbit_durable_queues: False
            delayed_delete: False
            scrub_time: 43200
            scrubber_datadir: /var/lib/glance/scrubber
            image_cache_dir: /var/lib/glance/image-cache/
            verbose: True
          glance_store:
            stores: rbd
            rbd_store_pool: images
            rbd_store_user: glance
            rbd_store_ceph_conf: /etc/ceph/ceph.conf
            rbd_store_chunk_size: 8
          database:
            connection: mysql://glance:{{ pillar['glance_dbpass'] }}@localhost/glance
          keystone_authtoken:
            auth_uri: http://172.16.128.2:5000
            auth_url: http://172.16.128.2:35357
            auth_plugin: password
            project_domain_id: default
            user_domain_id: default
            project_name: service
            username: glance
            password: {{ pillar['glance_pass'] }}
          paste_deploy:
            flavor: keystone