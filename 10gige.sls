net.core.rmem_max:
  sysctl.present:
    - value: 16777216

net.core.wmem_max:
  sysctl.present:
    - value: 16777216

net.ipv4.tcp_rmem:
  sysctl.present:
    - value: 4096 87380 16777216

net.ipv4.tcp_wmem:
  sysctl.present:
    - value: 4096 65536 16777216

net.core.netdev_max_backlog:
  sysctl.present:
    - value: 300000

net.ipv4.tcp_mtu_probing:
  sysctl.present:
    - value: 1

