dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-1.3.47.tar.gz
   - archive_format: tar
   - source_hash: md5=634c55130ce847a70dd0435d31815ad7
   - if_missing: /usr/src/i40e-1.3.47/
/usr/src/i40e-1.3.47/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
