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
  'r01c3b16':
    - passwords
