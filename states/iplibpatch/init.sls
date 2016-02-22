{% set os_family = salt['grains.get']('os_family', '') %}
ip_libpatch:
  file.patch:
{%if os_family == 'RedHat' %}
    - name: /usr/lib/python2.7/site-packages/neutron/agent/linux/ip_lib.py
{% else %}
    - name: /usr/lib/python2.7/dist-packages/neutron/agent/linux/ip_lib.py
{% endif %}
    - source: salt://iplibpatch/ip_lib.diff
{%if os_family == 'RedHat' %}
    - hash: md5=1fc996d5175919c87cd0e93c27a9dfbf
{% else %}
    - hash: md5=1fc996d5175919c87cd0e93c27a9dfbf
