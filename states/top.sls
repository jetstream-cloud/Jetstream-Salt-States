base:

  '*':
    - saltup.minion
    - bootstrap

  {{ pillar['salt-master-nodes'] }}:
    - saltup.master

  {{ pillar['nova-compute-nodes'] }}:
    - nova-compute

  {{ pillar['neutron-network-nodes'] }}:
    - neutron-network
