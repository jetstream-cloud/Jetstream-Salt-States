base:

  '*':
    - saltup.minion
    - bootstrap

  {{ pillar['salt-master-node'] }}:
    - saltup.master

  'js-129-114-104-9.*':
    - nova-compute
