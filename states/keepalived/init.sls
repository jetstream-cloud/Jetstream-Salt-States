{% set vi_1_state = salt['pillar.get']('keepalived:vi_1_state', salt['grains.get']('server_id')) %}
{% set vi_2_state = salt['pillar.get']('keepalived:vi_2_state', salt['grains.get']('server_id')) %}
{% set vi_1_priority = salt['pillar.get']('keepalived:vi_1_priority', salt['grains.get']('server_id')) %}
{% set vi_2_priority = salt['pillar.get']('keepalived:vi_2_priority', salt['grains.get']('server_id')) %}
{% set mcast_src_ip = salt['pillar.get']('keepalived:mcast_src_ip', salt['grains.get']('server_id')) %}
{% set password = salt['pillar.get']('keepalived:password', salt['grains.get']('server_id')) %}

keepalived:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/keepalived/keepalived.conf

/etc/keepalived/keepalived.conf:
  file.managed:
    - source: salt://keepalived/keepalived.conf
    - template: jinja
    - context:
      vi_1_state: {{ vi_1_state }} 
      vi_2_state: {{ vi_2_state }}
      vi_1_priority: {{ vi_1_priority }}
      vi_2_priority: {{ vi_2_priority }}
      mcast_src_ip: {{ mcast_src_ip }}
      password: {{ password }}
