openstack-nova-compute:
  pkg:
    - installed
    - required_in:
      - ini: /etc/nova/nova.conf
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/nova/nova.conf
      
sysfsutils:
  pkg.installed
libvirt:
  pkg.installed
  
libvirtd:
  service:
    - running
    - enable: True
    
include:
  - nova-compute.ceph

/root/secret.xml:
  file.managed:
    - source: salt://nova-compute/secret.xml
    - mode: 600

setsecret:
  cmd.run:
    - name: virsh secret-set-value --secret {{ pillar['libvirt_secret_uuid'] }} --base64 {{ pillar['cephclientcinderkey'] }}
    - onlyif: virsh secret-list |grep {{ pillar['libvirt_secret_uuid'] }}
    - unless: virsh secret-get-value --secret {{ pillar['libvirt_secret_uuid'] }}
  require:
    - file: /root/secret.xml
  
/etc/nova/nova.conf:
    ini.options_present:
    - sections:
        DEFAULT:
          rpc_backend: rabbit
          auth_strategy: keystone
          vnc_enabled: True
          vncserver_listen: 0.0.0.0
          vncserver_proxyclient_address: 172.16.128.2
          novncproxy_base_url: http://172.16.128.2:6080/vnc_auto.html
          verbose: True
{% for item in grains['fqdn_ip4'] %}
  {% if '172.16.128' in item %}
    {% set privateip = item %}
          my_ip: {{ privateip }}
  {% endif %}
{% endfor %}          
        libvirt:
          live_migration_flag: "VIR_MIGRATE_UNDEFINE_SOURCE,VIR_MIGRATE_PEER2PEER,VIR_MIGRATE_LIVE,VIR_MIGRATE_PERSIST_DEST"
          inject_password: false
          inject_key: false
          inject_partition: -2
          images_type: rbd
          images_rbd_pool: vms
          images_rbd_ceph_conf: /etc/ceph/ceph.conf
          rbd_user: cinder
          rbd_secret_uuid: {{ pillar['libvirt_secret_uuid'] }}
        oslo_messaging_rabbit:
          rabbit_host: 172.16.128.2
          rabbit_userid: openstack
          rabbit_password: {{ pillar['openstack_rabbit_pass'] }}
        keystone_authtoken:
          auth_uri: http://172.16.128.2:5000
          auth_url: http://172.16.128.2:35357
          auth_plugin: password
          project_domain_id: default
          user_domain_id: default
          project_name: service
          username: nova
          password: {{ pillar['nova_pass'] }}
        glance:
          host: 172.16.128.2
        oslo_concurrency:
          lock_path: /var/lock/nova