{% set os_family = salt['grains.get']('os_family', '') %}
{% set clustercheckuser_password = salt['pillar.get']('mysql_cluster_passwords:server:clustercheckuser_password', salt['grains.get']('server_id')) %}

perconarepo:
  pkgrepo.managed:
    - humanname: Percona Repo
    - name: deb http://repo.percona.com/apt vivid main
    - file: /etc/apt/sources.list.d/percona.list
    - keyserver: keys.gnupg.net 
    - keyid: CD2EFD2A 
    - require_in:
      - pkg: percona-xtradb-cluster-56

percona-xtradb-cluster-56:
  pkg.installed

/etc/mysql/conf.d/percona.cnf:
  file.managed:
    - source: salt://percona/percona.cnf
    - template: jinja
    - context:
      bkpuser_password: {{ pillar['bkpuser_password'] }}
/etc/xinetd.d/mysqlchk:
  file.managed:
    - source: salt://percona/mysqlchk
    - template: jinja
    - context:
      clustercheckuser_password: {{ pillar['clustercheckuser_password'] }}
xinetd:
  pkg:
    - installed
    - require_in:
      - file: /etc/xinetd.d/mysqlchk
  service:
    - running
    - enable: True 
    - watch:
      - file: /etc/xinetd.d/mysqlchk

mysql:
  service:
    - running
    - enable: True
    - watch:
      - file: /etc/mysql/conf.d/percona.cnf
{% if os_family =='RedHat' %}
MySQL-python:
  pkg.installed 
{% else %}
python-mysqldb:
  pkg.installed
{% endif %}   
