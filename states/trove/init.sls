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

/etc/trove/trove.conf:
  ini.options_present:
    - sections:
          DEFAULT:
            debug: True
            verbose: True
            rpc_backend: rabbit
            logdir: /var/log/trove
            trove_auth_url: https://{{ pillar['keystonehost'] }}:5000/v2.0
            nova_compute_url: https://{{ pillar['novapublichost'] }}:8774/v2
            cinder_url: https://{{ pillar['cinderpublichost'] }}:8776/v1
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
            rabbit_ha_queues: True
            rabbit_hosts: {{ pillar['rabbit_hosts'] }}
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
