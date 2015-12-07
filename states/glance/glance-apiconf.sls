/etc/glance/glance-api.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            show_image_direct_url: True
            verbose: True
          glance_store:
            default_store: rbd
            stores: rbd
            rbd_store_pool: images
            rbd_store_user: glance
            rbd_store_ceph_conf: /etc/ceph/ceph.conf
            rbd_store_chunk_size: 8
          database:
            connection: mysql://glance:{{ pillar['glance_dbpass'] }}@{{ pillar['mysqlhost'] }}/glance
          keystone_authtoken:
            auth_uri: http://{{ pillar['keystonehost'] }}:5000
            auth_url: http://{{ pillar['keystonehost'] }}:35357
            auth_plugin: password
            project_domain_id: default
            user_domain_id: default
            project_name: service
            username: glance
            password: {{ pillar['glance_pass'] }}
          paste_deploy:
            flavor: keystone
