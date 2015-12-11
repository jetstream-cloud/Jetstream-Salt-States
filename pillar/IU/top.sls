{{env}}:
  '*':
    - distro_specific
    - hosts
  'jblb1*':
    - jblb1_keepalived
  'jblb2*':
    - jblb2_keepalived
  'jbdb*':
    - mysql_cluster_passwords
    - passwords
    - mysql
    - hosts
  'r01c[34]b*':
    - passwords
    - hosts
