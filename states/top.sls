base:

  '*':
    - bootstrap

  storagetest:
    - taccceph

  stor01:
    - ceph
    - saltup.minion
    - bootstrap 
    - saltup.minion

  mpackard-dev-2.novalocal:
    - keystone
    - glance
    - nova
    - cinder

  mpackard-dev-3.novalocal:
    - keystone
    - glance
    - nova
    - cinder
  
  mpackard-dev-4.novalocal:
    - keystone
    - glance
    - nova
    - cinder
