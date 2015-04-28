jomlowe:
  user.present:
    - groups:
      - adm
      - sudo
  ssh_auth:
    - present
    - source: salt://sshkeys/jomlowe_id_dsa.pub
    - require:
      - user: jomlowe

turnerg:
  user.present:
    - groups:
      - adm
      - sudo
  ssh_auth:
    - present
    - source: salt://sshkeys/turnerg_id_rsa.pub
    - require:
      - user: turnerg

plinden:
  user.present:
    - groups:
      - adm
      - sudo
  ssh_auth:
    - present
    - source: salt://sshkeys/plinden_id_rsa.pub
    - require:
      - user: plinden

bret:
  user.present:
    - groups:
      - adm
      - sudo
  ssh_auth:
    - present
    - source: salt://sshkeys/bret_id_dsa.pub
    - require:
      - user: bret
