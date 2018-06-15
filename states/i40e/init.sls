dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-2.4.10.tar.gz
   - archive_format: tar
   - source_hash: md5=379793d1e3eb408a1a46ddeee94bc27b
   - if_missing: /usr/src/i40e-2.4.10/
/usr/src/i40e-2.4.10/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
