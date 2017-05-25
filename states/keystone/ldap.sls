perl-LDAP:
  pkg.installed
openldap-servers:
  pkg.installed
openldap-clients:
  pkg.installed
openldap:
  pkg.installed

/etc/openldap/bin/pull.sh:
  file.managed:
    - source: salt://keystone/pull.sh
    - owner: root
    - group: root
    - template: jinja
    - require:
      - pkg: perl-LDAP
      - pkg: openldap
    - context:
      cephkey: {{ pillar['tacc_ldap_pass'] }}
/etc/openldap/bin/iu.secret:
    - source: salt://keystone/iu.secret
    - owner: root
    - group: root
    - template: jinja
    - require:
      - pkg: perl-LDAP
      - pkg: openldap
    - context:
      cephkey: {{ pillar['ldap_pass'] }}
/etc/openldap/bin/tacc2jetstream:
  file.managed:
    - source: salt://keystone/tacc2jetstream
    - owner: root
    - group: root
    - template: jinja
    - require:
      - pkg: perl-LDAP
      - pkg: openldap


