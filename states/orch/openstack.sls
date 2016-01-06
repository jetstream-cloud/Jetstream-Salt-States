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
      - salt: keystonedb_setup

glancedb_setup:
  salt.state:
    - tgt: 'jbdb1*'
    - sls: glance.glancedb
    - require:
      - salt: databasecluster_setup
      - salt: haproxy_keepalived_setup

glancekeystone_setup:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: glance.glancekeystone
    - require:
      - salt: keystoneservice

glanceservice:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: glance
    - require:
      - salt: glancedb_setup
      - salt: glancekeystone_setup

cinderdb_setup:
  salt.state:
    - tgt: 'jbdb1*'
    - sls: cinder.cinderdb
    - require:
      - salt: databasecluster_setup
      - salt: haproxy_keepalived_setup

cinderkeystone_setup:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: cinder.cinderkeystone
    - require:
      - salt: keystoneservice

cinderservice:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: cinder
    - require:
      - salt: cinderdb_setup
      - salt: cinderkeystone_setup

novadb_setup:
  salt.state:
    - tgt: 'jbdb1*'
    - sls: nova.novadb
    - require:
      - salt: databasecluster_setup
      - salt: haproxy_keepalived_setup

novakeystone_setup:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: nova.novakeystone
    - require:
      - salt: keystoneservice

novaservice:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: nova
    - require:
      - salt: novadb_setup
      - salt: novakeystone_setup

neutrondb_setup:
  salt.state:
    - tgt: 'jbdb1*'
    - sls: neutron.neutrondb
    - require:
      - salt: databasecluster_setup
      - salt: haproxy_keepalived_setup

neutronkeystone_setup:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: neutron.neutronkeystone
    - require:
      - salt: keystoneservice

neutronservice:
  salt.state:
    - tgt: 'r01c3b16'
    - sls: neutron
    - require:
      - salt: neutrondb_setup
      - salt: neutronkeystone_setup

neutronnetwork:
  salt.state:
    - tgt: 'r04c4b16'
    - sls: neutron-network
    - require:
      - salt: neutronservice

nova-compute-setup:
  salt.sate:
    - tgt: 'r*c[12]b*'
    - sls: nova-compute
    - require: 
      - salt: novaservice
      - salt: neutronservice
      - salt: neutronnetwork
      - salt: glanceservice
      - salt: cinderservice
