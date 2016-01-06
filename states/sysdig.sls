{% set os_family = salt['grains.get']('os_family', '') %}

sysdigrepo:
  pkgrepo.managed:
{% if os_family == 'RedHat' %}
    - name: draios
    - baseurl: http://download.draios.com/stable/rpm/$basearch
    - gpgcheck: 1
    - gpgkey: https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public 
{% elif os_family == 'Debian' %}
    - name: deb http://download.draios.com/stable/deb stable-$(ARCH)/
    - file: /etc/apt/sources.list.d/draios.list
{% endif %}
    - humanname: Draios
    - key_url: https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public

sysdig:
  pkg.installed   
