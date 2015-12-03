databasecluster_setup:
  salt.state:
    - tgt: 'jbdb*'
    - sls: percona

haproxy_keepalived_setup:
  salt.state:
    - tgt: 'jblb*'
    - sls: 
      - haproxy
      - keepalived

keystonedb_setup:
  salt.state:
    - tgt: 'jbdb1*'
    - sls: keystone.keystonedb
    - require:
      - salt: databasecluster_setup
      - salt: haproxy_keepalived_setup

