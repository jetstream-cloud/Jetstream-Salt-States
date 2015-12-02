databasecluster_setup:
  salt.state:
    - tgt: 'jbdb*'
    - highstate: True

haproxy_setup:
  salt.state:
    - tgt: 'jblb*'
    - highstate: True

keystonedb_setup:
  salt.state:
    - tgt: 'jbdb1*'
    - sls: keystone.keystonedb
    - require:
      - salt: databasecluster_setup

