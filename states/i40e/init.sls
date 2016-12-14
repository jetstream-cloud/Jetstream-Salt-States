dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-1.5.25.tar.gz
   - archive_format: tar
   - source_hash: md5=395dbcbb2792b6681f4482404e8f070c
   - if_missing: /usr/src/i40e-1.5.25/
/usr/src/i40e-1.5.25/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
