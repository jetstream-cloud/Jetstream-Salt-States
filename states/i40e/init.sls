dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-1.6.42.tar.gz
   - archive_format: tar
   - source_hash: md5=27ab74640f3fbab64b88f2c8d5dccaa9
   - if_missing: /usr/src/i40e-1.6.42/
/usr/src/i40e-1.6.42/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
