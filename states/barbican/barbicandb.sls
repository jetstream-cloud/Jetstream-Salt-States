{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

barbican:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - requirein:
      - mysql_user: barbicanlocalhost
      - mysql_grants: barbicanlocalhost
      - mysql_user: barbicanewildcard
      - mysql_grans: barbicanwildcard
      
barbicanlocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: localhost
    - name: barbican
    - password: {{ pillar['barbican_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: barbican.*
    - user: barbican
    - host: localhost

barbicanwildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: barbican
    - password: {{ pillar['barbican_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: barbican.*
    - user: barbican
    - host: "%"
