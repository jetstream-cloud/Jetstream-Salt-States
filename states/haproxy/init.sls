mysql_ufw_rule:
  cmd.run:
    - name: ufw allow from 172.16.128.0/20 to any port 3306 proto tcp
/etc/haproxy/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/haproxy.cfg

haproxy:
  pkg.installed:
    - require_in:
      - file: /etc/haproxy/haproxy.cfg
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
