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
      vi_1_state: {{ pillar['keepalived']['vi_1_state'] }} 
      vi_2_state: {{ pillar['keepalived']['vi_2_state'] }}
      vi_1_priority: {{ pillar['keepalived']['vi_1_priority'] }}
      vi_2_priority: {{ pillar['keepalived']['vi_2_priority'] }}
      mcast_src_ip: {{ pillar['keepalived']['mcast_src_ip'] }}
      password: {{ pillar['keepalived']['password'] }}
