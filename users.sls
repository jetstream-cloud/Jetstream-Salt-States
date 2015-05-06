sudogroup:
  group.present:
    - name: sudo

jomlowe:
  user.present:
    - groups:
      - wheel
      - adm
      - sudo
  ssh_auth:
    - user: jomlowe
    - present
    - source: salt://sshkeys/jomlowe_id_dsa.pub
    - require:
      - user: jomlowe

turnerg:
  user.present:
    - groups:
      - wheel
      - adm
      - sudo
  ssh_auth:
    - user: turnerg
    - present
    - source: salt://sshkeys/turnerg_id_rsa.pub
    - require:
      - user: turnerg

plinden:
  user.present:
    - groups:
      - wheel
      - adm
      - sudo
  ssh_auth:
    - user: plinden
    - present
    - source: salt://sshkeys/plinden_id_rsa.pub
    - require:
      - user: plinden

bret:
  user.present:
    - groups:
      - wheel
      - adm
      - sudo
  ssh_auth:
    - user: bret
    - present
    - source: salt://sshkeys/bret_id_dsa.pub
    - require:
      - user: bret
rootrsa:
  ssh_auth:
    - present
    - user: root
    - source: salt://sshkeys/jam1_id_rsa.pub


