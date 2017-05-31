memcached:
  pkg:
    - installed
  service:
    - running
    - enable: True
    - watch:
      - ini: /etc/sysconfig/memcached
/etc/sysconfig/memcached:
  file.managed:
    - source: salt://memcache/memcached
