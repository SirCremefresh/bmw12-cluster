
k create namespace ldap
k apply -f certificate-prod.yaml
helm install -n ldap ldap stable/openldap --values ldap-values.yaml --values ldap-values-passwords.plain-yaml

helm upgrade -n ldap ldap stable/openldap --values ldap-values.yaml --values ldap-values-passwords.plain-yaml


export LDAP_ADMIN_PASSWORD= #ADMIN_PW
# search all
ldapsearch -x -H ldap://ldap.intra.bmw12.ch:389 -b dc=bmw12,dc=ch -D "cn=admin,dc=bmw12,dc=ch" -w $LDAP_ADMIN_PASSWORD


ldapsearch -x -H ldap://ldap.intra.bmw12.ch:389 -b dc=bmw12,dc=ch -D "cn=admin,dc=bmw12,dc=ch" -w $LDAP_ADMIN_PASSWORD
ldapsearch -x -H ldap://ldap.intra.bmw12.ch:389 -b cn=database,ou=groups,dc=bmw12,dc=ch -D "cn=admin,dc=bmw12,dc=ch" -w $LDAP_ADMIN_PASSWORD


# add groups and ou
ldapadd -x -H ldap://ldap.intra.bmw12.ch:389 -D "cn=admin,dc=bmw12,dc=ch" -f ou.ldif -w $LDAP_ADMIN_PASSWORD
ldapadd -x -H ldap://ldap.intra.bmw12.ch:389 -D "cn=admin,dc=bmw12,dc=ch" -f groups.ldif -w $LDAP_ADMIN_PASSWORD


# add bmw12_iot user
ldapadd -x -H ldap://ldap.intra.bmw12.ch:389 -D "cn=admin,dc=bmw12,dc=ch" -f bmw12_iot.ldif -w $LDAP_ADMIN_PASSWORD

## change and add password
ldappasswd -x -H ldap://ldap.intra.bmw12.ch:389 -D "cn=admin,dc=bmw12,dc=ch" -S "uid=bmw12_iot4,ou=users,dc=bmw12,dc=ch"  -w $LDAP_ADMIN_PASSWORD
