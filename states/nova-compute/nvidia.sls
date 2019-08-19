
/etc/modprobe.d/nvidia-installer-disable-nouveau.conf:
  file.managed:
    - source: salt://nova-compute/nvidia-installer-disable-nouveau.conf
