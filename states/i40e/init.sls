dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-2.4.6.tar.gz
   - archive_format: tar
   - source_hash: md5=66455ad991f7fd81cf4ce3d2430db434
   - if_missing: /usr/src/i40e-2.4.6/
/usr/src/i40e-2.4.6/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
