base:
  '*':
    - distro_specific
    - hosts
    - openstack_settings
  'jblb1*':
    - jblb1_keepalived
    - lbstatsauth
  'jblb2*':
    - jblb2_keepalived
    - lbstatsauth
  'jbdb*':
    - mysql_cluster_passwords
    - passwords
    - mysql
    - hosts
  'r0[1-8]c[1234]b*':
    - passwords
    - hosts
  'r08g*':
    - paswords
    - hosts
  'jbm1':
    - passwords
