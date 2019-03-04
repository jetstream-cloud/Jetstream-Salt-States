python-troveclient:
  pkg.installed

openstack-trove:
  pkg:
    - installed
    - required_in:
      - ini: /etc/trove/trove.conf
  cmd.run:
    - name: su -s /bin/sh -c "trove-db-manage upgrade head" trove
    - stateful: True
    - require:
      - pkg: openstack-trove
      - ini: /etc/trove/trove.conf

openstack-trove-api:
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/trove/trove.conf
    - require:
      - cmd: openstack-trove
openstack-trove-engine:
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/trove/trove.conf
    - require:
      - cmd: openstack-trove
/etc/trove/trove-taskmanager.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            debug: True
            verbose: True
            rpc_backend: rabbit
            logdir: /var/log/trove
            trove_auth_url: https://{{ pillar['keystonehost'] }}:5000/v3
            nova_compute_url: https://{{ pillar['novapublichost'] }}:8774/v2
            cinder_url: https://{{ pillar['cinderpublichost'] }}:8776/v2
            nova_proxy_admin_user: admin
            nova_proxy_admin_pass: 
            nova_proxy_admin_tenant_name: service
            taskmanager_manager: trove.taskmanager.manager.Manager
            use_nova_server_config_drive: True
            network_driver: trove.network.neutron.NeutronDriver
            network_label_regex: .*
          database:
            connection: mysql://trove:{{ pillar['trove_dbpass']}}@{{ pillar['mysqlhost'] }}/trove
          oslo_messaging_rabbit:
            rabbit_host: localhost
            rabbit_userid:
            rabbit_password:

/etc/trove/trove-conductor.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            debug: True
            verbose: True
            rpc_backend: rabbit
            logdir: /var/log/trove
            trove_auth_url: https://{{ pillar['keystonehost'] }}:5000/v3
            nova_compute_url: https://{{ pillar['novapublichost'] }}:8774/v2
            cinder_url: https://{{ pillar['cinderpublichost'] }}:8776/v2
          database:
            connection: mysql://trove:{{ pillar['trove_dbpass']}}@{{ pillar['mysqlhost'] }}/trove
          oslo_messaging_rabbit:
            rabbit_host: localhost 
            rabbit_userid:
            rabbit_password:

/etc/trove/trove-guestagent.conf:
  ini.options_present:
    - sections:
          oslo_messaging_rabbit:
            rabbit_port: 5673
            rabbit_host: murano1.iu.jetstream-cloud.org
            rabbit_password:  
            rabbit_use_ssl: True
/etc/trove/trove.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            debug: True
            verbose: True
            rpc_backend: rabbit
            logdir: /var/log/trove
            trove_auth_url: https://{{ pillar['keystonehost'] }}:5000/v3
            nova_compute_url: https://{{ pillar['novapublichost'] }}:8774/v2
            cinder_url: https://{{ pillar['cinderpublichost'] }}:8776/v2
            swift_url: https://{{ pillar['swiftpublichost'] }}:8080/v1/AUTH_
            notifier_queue_hostname: controller
            auth_strategy: keystone
            add_addresses: True
            network_label_regex: ^NETWORK_LABEL$
            api_paste_config: /etc/trove/api-paste.ini
          database:
            connection: mysql://trove:{{ pillar['trove_dbpass']}}@{{ pillar['mysqlhost'] }}/trove
          oslo_messaging_notifications:
            driver: messagingv2
            enable: True
          oslo_messaging_rabbit:
            rabbit_host: localhost
            rabbit_userid: openstack
            rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
          keystone_authtoken:
            auth_uri: https://{{ pillar['keystonehost'] }}:5000
            auth_url: https://{{ pillar['keystonehost'] }}:35357
            memcached_servers: 172.16.129.48:11211,172.16.129.112:11211,172.16.129.176:11211
            auth_type: password
            project_domain_name: default
            user_domain_name: default
            project_name: service
            username: trove
            password: {{ pillar['trove_pass'] }}
