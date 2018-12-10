{% set rabbit_credential = ['openstack',pillar['openstack_rabbit_pass']]|join(':') %}
{% set rabbit_hosts_list = pillar['rabbit_hosts'].split(',') %}

glance-api.conf-deprecated:
  ini.options_absent:
    - name: /etc/glance/glance-api.conf
    - sections:
        DEFAULT:
          notification_driver
          rpc_backend
          show_multiple_locations
        keystone_authtoken:
          auth_plugin
          auth_uri
        oslo_messaging_rabbit:
          rabbit_hosts
          rabbit_userid
          rabbit_password
/etc/glance/glance-api.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            workers: 4
            show_image_direct_url: True
            verbose: True
            notification_driver: messagingv2
            transport_url: rabbit://{% for item in rabbit_hosts_list %}{{rabbit_credential}}@{{item}}:5672,{% endfor %}
          glance_store:
            default_store: rbd
            stores: rbd
            rbd_store_pool: glance-images
            rbd_store_user: glance
            rbd_store_ceph_conf: /etc/ceph/ceph.conf
            rbd_store_chunk_size: 8
          database:
            connection: mysql+pymysql://glance:{{ pillar['glance_dbpass'] }}@{{ pillar['mysqlhost'] }}/glance
          keystone_authtoken:
            memcached_servers: {{ pillar['memcached_servers'] }}
            www_authenticate_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            auth_type: password
            project_domain_id: default
            user_domain_id: default
            project_name: service
            username: glance
            password: {{ pillar['glance_pass'] }}
          oslo_messaging_notifications:
            driver: messagingv2
          oslo_messaging_rabbit:
            rabbit_ha_queues: True
          paste_deploy:
            flavor: keystone
          taskflow_executor:
            converstion_format: raw
