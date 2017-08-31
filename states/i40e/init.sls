dkms:
  pkg.installed

i40e-tarball:
  archive.extracted:
   - name: /usr/src/
   - source: salt://i40e-2.1.26.tar.gz
   - archive_format: tar
   - source_hash: md5=c8fb23ee8b7f18d00f5c46b88b4ad39e
   - if_missing: /usr/src/i40e-2.1.26/
/usr/src/i40e-2.1.26/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
