{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

cinder:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - requirein:
      - mysql_user: cinderlocalhost
      - mysql_grants: cinderlocalhost
      - mysql_user: cinderewildcard
      - mysql_grans: cinderwildcard
      
cinderlocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: localhost
    - name: cinder
    - password: {{ pillar['cinder_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: cinder.*
    - user: cinder
    - host: localhost

cinderwildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - host: "%"
    - name: cinder
    - password: {{ pillar['cinder_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - grant: all privileges
    - database: cinder.*
    - user: cinder
    - host: "%"
