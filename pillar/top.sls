{{env}}:
  '*':
    - test
    - distro_specific
  'jab02':
    - passwords
    - mysql
    - c1hosts
  'jab0[3-5]':
    - passwords
    - c1hosts
  'jab12':
    - passwords
    - mysql
    - c2hosts
