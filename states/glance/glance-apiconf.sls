/etc/glance/glance-api.conf:
  ini.options_present:
    - require:
      - cleanup_glanceconf
    - sections:
          DEFAULT:
            workers: 4
            show_image_direct_url: True
            verbose: True
            notification_driver: messagingv2
            rpc_backend: rabbit
          glance_store:
            default_store: rbd
            stores: rbd
            rbd_store_pool: glance-images
            rbd_store_user: glance
            rbd_store_ceph_conf: /etc/ceph/ceph.conf
            rbd_store_chunk_size: 8
          database:
            connection: mysql://glance:{{ pillar['glance_dbpass'] }}@{{ pillar['mysqlhost'] }}/glance
          keystone_authtoken:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            auth_plugin: password
            project_domain_id: default
            user_domain_id: default
            project_name: service
            username: glance
            password: {{ pillar['glance_pass'] }}
          oslo_messaging_rabbit:
            rabbit_ha_queues: True
            rabbit_hosts: {{ pillar['rabbit_hosts'] }}
            rabbit_userid: openstack
            rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
          paste_deploy:
            flavor: keystone
          taskflow_executor:
            converstion_format: raw
