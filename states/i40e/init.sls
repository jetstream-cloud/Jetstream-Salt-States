dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-2.4.3.tar.gz
   - archive_format: tar
   - source_hash: md5=532cc3e782492b4dfd00a14ca4d8b11e
   - if_missing: /usr/src/i40e-2.4.3/
/usr/src/i40e-2.4.3/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
