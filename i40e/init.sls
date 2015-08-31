

i40e-tarball:
  archive.extracted:
   - name: /usr/src/i40e-1.3.38
   - source: http://downloads.sourceforge.net/project/e1000/i40e%20stable/1.3.38/i40e-1.3.38.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fe1000%2Ffiles%2Flatest%2Fdownload&ts=1440789680&use_mirror=skylineservers
   - archive_format: tar
   - source_hash: md5=68d786d43ebb3bae78b9ba52df6baa3c
/usr/src/i40e-1.3.38/dkms.conf:
  file.managed:
    - source: salt://i40e/dkms.conf
    - mode: 644
    - require:
      - archive: i40e-tarball
