base:

#  '*':
#    - saltup.minion

  storagetest:
    - taccceph

  stor01:
    - ceph
    - saltup.minion
    - bootstrap 
    - saltup.minion
