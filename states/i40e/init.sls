dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-2.7.26.tar.gz
   - archive_format: tar
   - source_hash: md5=c482c8d2a7bf11a64966fa36903144bc
   - if_missing: /usr/src/i40e-2.7.26/
/usr/src/i40e-2.7.26/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
