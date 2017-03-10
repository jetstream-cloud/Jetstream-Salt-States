{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

sahara:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - requirein:
      - mysql_user: saharalocalhost
      - mysql_grants: saharalocalhost
      - mysql_user: saharaewildcard
      - mysql_grans: saharawildcard
      
saharalocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: localhost
    - name: sahara
    - password: {{ pillar['sahara_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: sahara.*
    - user: sahara
    - host: localhost

saharawildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: sahara
    - password: {{ pillar['sahara_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: sahara.*
    - user: sahara
    - host: "%"
