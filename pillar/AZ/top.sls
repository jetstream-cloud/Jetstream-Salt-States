{{env}}:
  '*':
    - distro_specific
  'jab02':
    - passwords
    - mysql
    - c1hosts
    - cephkeys
  'jab0[3-5]':
    - passwords
    - c1hosts
    - cephkeys
  'jab12':
    - passwords
    - mysql
    - c2hosts
    - cephkeys
