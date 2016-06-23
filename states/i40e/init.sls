dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-1.5.18.tar.gz
   - archive_format: tar
   - source_hash: md5=d3108a0380fcab8985f20bafe4839cc5
   - if_missing: /usr/src/i40e-1.5.18/
/usr/src/i40e-1.5.18/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
