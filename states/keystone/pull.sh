#!/bin/bash

newldif="/tmp/chameleon.ldif"
#rundir="/root/updateldap"
rundir=$PWD

grep -v authorizedService <(
echo -e "dn: dc=tacc,dc=utexas,dc=edu
dc: tacc
o: TACC
objectClass: dcObject
objectClass: organization
objectClass: top

dn: ou=People,dc=tacc,dc=utexas,dc=edu
objectClass: organizationalUnit
ou: People

dn: ou=Systems,dc=tacc,dc=utexas,dc=edu
objectClass: organizationalUnit
ou: Systems
"

ldapsearch -LLL -x -h ldap.tacc.utexas.edu -D "uid=jetsync,ou=People,dc=tacc,dc=utexas,dc=edu" -w {{ tacc_ldap_pass }} -b "ou=People,dc=tacc,dc=utexas,dc=edu" "(host=jetstream.tacc.utexas.edu)"

ldapsearch -LLL -x -h ldap.tacc.utexas.edu -D "uid=jetsync,ou=People,dc=tacc,dc=utexas,dc=edu" -w {{ tacc_ldap_pass }} -b "ou=Jetstream,ou=Systems,dc=tacc,dc=utexas,dc=edu" "(objectClass=*)"
)
