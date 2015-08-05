{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

mariadbrepo:
  pkgrepo.managed:
    - humanname: MariaDB
    - baseurl: http://yum.mariadb.org/10.0/centos7-amd64
    - gpgcheck: 1
    - gpgkey: https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    - requirein:
      - pkg: MariaDB-server
      - pkg: MariaDB-client

MariaDB-server:
  pkg.installed 
MariaDB-client:
  pkg.installed 
MySQL-python:
  pkg.installed

 
mysql:
  service:
    - running
    - enable: True
    - require:
      - pkg: MariaDB-server
    - watch:
      - file: /etc/my.cnf.d/server.cnf

/etc/my.cnf.d/server.cnf:
  file.managed:
    - source: salt://mariadb/server.cnf
    - template: jinja
    - context:
      mysqlhost: {{ pillar['mysqlhost'] }}

mysql_root_password:
  cmd.run:
    - name: mysqladmin --user root password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mysql
