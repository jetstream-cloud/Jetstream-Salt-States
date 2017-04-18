dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-2.0.23.tar.gz
   - archive_format: tar
   - source_hash: md5=9b8924767447ee3b0900b148c36a625e
   - if_missing: /usr/src/i40e-2.0.23/
/usr/src/i40e-2.0.23/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
