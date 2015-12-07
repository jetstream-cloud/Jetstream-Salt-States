{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

glance:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: localhost
    - connection_charset: utf8
    - requirein:
      - mysql_user: glancelocalhost
      - mysql_grants: glancelocalhost
      - mysql_user: glanceewildcard
      - mysql_grans: glancewildcard
      
glancelocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: localhost
    - name: glance
    - password: {{ pillar['glance_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: localhost

glancewildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: glance
    - password: {{ pillar['glance_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: "%"
