memcached:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/sysconfig/memcached
/etc/sysconfig/memcached:
  file.managed:
    - source: salt://memcache/memcached
