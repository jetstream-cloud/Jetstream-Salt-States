dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-1.4.25.tar.gz
   - archive_format: tar
   - source_hash: md5=b49e117137322788d379ab0ec19b1b6f
   - if_missing: /usr/src/i40e-1.4.25/
/usr/src/i40e-1.4.25/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
