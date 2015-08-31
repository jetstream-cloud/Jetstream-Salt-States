

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-1.3.38.tar.gz
   - archive_format: tar
   - source_hash: md5=68d786d43ebb3bae78b9ba52df6baa3c
   - if_missing: /usr/src/i40e-1.3.38/
/usr/src/i40e-1.3.38/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
