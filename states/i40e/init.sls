dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-2.4.6.tar.gz
   - archive_format: tar
   - source_hash: md5=830e0b47c405d2dc0d2bbe46c3451ad0
   - if_missing: /usr/src/i40e-2.4.6/
/usr/src/i40e-2.4.6/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
