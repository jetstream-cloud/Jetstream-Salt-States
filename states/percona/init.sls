{% set os_family = salt['grains.get']('os_family', '') %}
{% set clustercheckuser_password = salt['pillar.get']('mysql_cluster_passwords:server:clustercheckuser_password', salt['grains.get']('server_id')) %}

{% if os_family =='RedHat' %}
percona-release:
  pkg.installed:
    - sources: 
      - foo: http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm
{% endif %}

{% if os_family =='Debian' %}
perconarepo:
  pkgrepo.managed:
    - humanname: Percona Repo
    - name: deb http://repo.percona.com/apt vivid main
    - file: /etc/apt/sources.list.d/percona.list
    - keyserver: keys.gnupg.net 
    - keyid: CD2EFD2A 
    - require_in:
      - pkg: Percona-XtraDB-Cluster-57
{% endif %}   

Percona-XtraDB-Cluster-57:
  pkg.installed

"{{ pillar['mysql-confdir'] }}/percona.cnf":
  file.managed:
    - source: salt://percona/percona.cnf
    - template: jinja
    - context:
        bkpuser_password: {{ pillar['bkpuser_password'] }}
        percona_hosts: {{ pillar['percona_hosts'] }}

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
      - file: "{{ pillar['mysql-confdir'] }}/percona.cnf"
{% if os_family =='RedHat' %}
MySQL-python:
  pkg.installed 
{% else %}
python-mysqldb:
  pkg.installed
{% endif %}   
