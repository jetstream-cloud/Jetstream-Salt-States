databasecluster_setup:
  salt.state:
    - tgt: 'jbdb*'
    - highstate: True

haproxy_setup:
  salt.state:
    - tgt: 'jblb*'
    - highstate: True


