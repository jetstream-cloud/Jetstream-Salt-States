databasecluster_setup:
  salt.state:
    - tgt: 'jbdb*'
    - highstate: True
