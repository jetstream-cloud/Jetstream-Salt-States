{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

mistral:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - requirein:
      - mysql_user: mistrallocalhost
      - mysql_grants: mistrallocalhost
      - mysql_user: mistralewildcard
      - mysql_grans: mistralwildcard
      
mistrallocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - host: localhost
    - name: mistral
    - password: {{ pillar['mistral_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - grant: all privileges
    - database: mistral.*
    - user: mistral
    - host: localhost

mistralwildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: mistral
    - password: {{ pillar['mistral_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: mistral.*
    - user: mistral
    - host: "%"
