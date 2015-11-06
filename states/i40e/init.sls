

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-1.3.46.tar.gz
   - archive_format: tar
   - source_hash: md5=b9d0ba0d4de3e72653c9d5e5667157c6
   - if_missing: /usr/src/i40e-1.3.46/
/usr/src/i40e-1.3.46/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
