{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

heat:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - requirein:
      - mysql_user: heatlocalhost
      - mysql_grants: heatlocalhost
      - mysql_user: heatewildcard
      - mysql_grans: heatwildcard
      
heatlocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - host: localhost
    - name: heat
    - password: {{ pillar['heat_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - grant: all privileges
    - database: heat.*
    - user: heat
    - host: localhost

heatwildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: heat
    - password: {{ pillar['heat_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: heat.*
    - user: heat
    - host: "%"
