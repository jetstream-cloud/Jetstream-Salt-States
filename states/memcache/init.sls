memcached:
  pkg.installed

/etc/sysconfig/memcached:
  file.managed:
    - source: salt://memcache/memcached
