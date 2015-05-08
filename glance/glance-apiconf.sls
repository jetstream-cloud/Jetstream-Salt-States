/etc/glance/glance-api.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            default_store: rbd
            show_image_direct_url: True
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