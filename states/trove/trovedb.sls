{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

trove:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - requirein:
      - mysql_user: trovelocalhost
      - mysql_grants: trovelocalhost
      - mysql_user: troveewildcard
      - mysql_grans: trovewildcard
      
trovelocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: localhost
    - name: trove
    - password: {{ pillar['trove_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: trove.*
    - user: trove
    - host: localhost

trovewildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: trove
    - password: {{ pillar['trove_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: trove.*
    - user: trove
    - host: "%"
