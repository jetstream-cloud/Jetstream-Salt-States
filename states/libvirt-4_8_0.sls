libvirt-4.8.0-tarball:
  archive.extracted:
   - name: /root/
   - source: salt://libvirt-4.8.0.tar
   - archive_format: tar
   - source_hash: md5=7f7cbfc94ee720751b7e3de78eb9f082
   - if_missing: /root/libvirt-4.8.0/
