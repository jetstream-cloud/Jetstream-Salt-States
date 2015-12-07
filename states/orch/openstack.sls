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

keystoneservice:
  salt.sate:
    - tgt: 'r01c3b16'
    - sls: keystone
    - require:
      - salt: keystonedb_setup:

glancedb_setup:
  salt.state:
    - tgt: 'jbdb1*'
    - sls: glance.glancedb
    - require:
      - salt: databasecluster_setup
      - salt: haproxy_keepalived_setup

glanceservice:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: keystone
    - require:
      - salt: glancedb_setup


