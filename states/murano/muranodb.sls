{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

murano:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - requirein:
      - mysql_user: muranolocalhost
      - mysql_grants: muranolocalhost
      - mysql_user: muranoewildcard
      - mysql_grans: muranowildcard
      
muranolocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - host: localhost
    - name: murano
    - password: {{ pillar['murano_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - grant: all privileges
    - database: murano.*
    - user: murano
    - host: localhost

muranowildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: murano
    - password: {{ pillar['murano_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: murano.*
    - user: murano
    - host: "%"
