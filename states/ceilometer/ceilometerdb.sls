{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

ceilometer:
    mysql_database.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - requirein:
      - mysql_user: ceilometerlocalhost
      - mysql_grants: ceilometerlocalhost
      - mysql_user: ceilometerewildcard
      - mysql_grans: ceilometerwildcard
      
ceilometerlocalhost:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - host: localhost
    - name: ceilometer
    - password: {{ pillar['ceilometer_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password  }}
    - connection_host: {{ pillar['mysqlhost'] }} 
    - connection_charset: utf8
    - grant: all privileges
    - database: ceilometer.*
    - user: ceilometer
    - host: localhost

ceilometerwildcard:
  mysql_user.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - host: "%"
    - name: ceilometer
    - password: {{ pillar['ceilometer_dbpass'] }}
  mysql_grants.present:
    - connection_user: root
    - connection_pass: {{ mysql_root_password }}
    - connection_host: {{ pillar['mysqlhost'] }}
    - connection_charset: utf8
    - grant: all privileges
    - database: ceilometer.*
    - user: ceilometer
    - host: "%"
