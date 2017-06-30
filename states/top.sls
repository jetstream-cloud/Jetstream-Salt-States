base:

  '*':
    - saltup.minion

  {{ pillar['salt-master-node'] }}:
    - saltup.master

