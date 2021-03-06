{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}
{% set os_family = salt['grains.get']('os_family', '') %}

mariadbrepo:
  pkgrepo.managed:
    - humanname: MariaDB
{% if os_family == 'RedHat' %}    
    - baseurl: http://yum.mariadb.org/10.0/centos7-amd64
    - gpgcheck: 1
    - gpgkey: https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
{% endif %}
{% if os_family == 'Debian' %}
    - name: deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/ubuntu trusty main
    - file: /etc/apt/sources.list.d/mariadb.list
    - key_url: http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xCBCB082A1BB943DB
{% endif %}
    - requirein:
      - pkg: MariaDB-server
      - pkg: MariaDB-client

MariaDB-server:
  pkg:
{% if os_family == 'Debian' %}
    - name: mariadb-server
{% endif %}
    - installed 
{% if os_family == 'RedHat' %}    
MariaDB-client:
  pkg.installed
   
MySQL-python:
  pkg.installed
{% endif %}
{% if os_family == 'Debian' %}
python-mysqldb:
  pkg.installed
{% endif %}
 
mysql:
  service:
    - running
    - enable: True
    - require:
      - pkg: MariaDB-server
{% if os_family == 'RedHat' %}         
    - watch:
      - file: /etc/my.cnf.d/server.cnf
{% endif %}

{% if os_family == 'RedHat' %}
/etc/my.cnf.d/server.cnf:
  file.managed:
    - source: salt://mariadb/server.cnf
    - template: jinja
    - context:
      mysqlhost: {{ pillar['mysqlhost'] }}
{% endif %}

mysql_root_password:
  cmd.run:
    - name: mysqladmin --user root password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mysql
