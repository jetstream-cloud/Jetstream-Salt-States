{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set os_family = salt['grains.get']('os_family', '') %}

test:
  test.nop:
  - wow1: {{ mysql_root_password }}



mysql-prereq-packages:
  pkg.installed:
{% if os_family == 'Debian' %}
    - pkgs:
      - mariadb-server
      - python-mysqldb
{% endif %}
{% if os_family == 'RedHat' %}
    - pkgs:
      - mariadb
      - MySQL-python
{% endif %}

mysql:
  service:
    - running
    - enable: True
    - require:
      - mysql-prereq-packages
{% if os_family == 'RedHat' %}         
    - watch:
      - file: /etc/my.cnf.d/server.cnf
{% endif %}

#{% if os_family == 'RedHat' %}
#/etc/my.cnf.d/server.cnf:
#  file.managed:
#    - source: salt://mariadb/server.cnf
#    - template: jinja
#    - context:
#      mysqlhost: {{ pillar['mysqlhost'] }}
#{% endif %}

mysql_root_password:
  cmd.run:
    - name: mysqladmin --user root password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mysql
