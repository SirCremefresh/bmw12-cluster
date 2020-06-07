
k create namespace ldap
k apply -f certificate-prod.yaml
helm install -n ldap ldap stable/openldap --values ldap-values.yaml --values ldap-values-passwords.plain-yaml

helm upgrade -n ldap ldap stable/openldap --values ldap-values.yaml --values ldap-values-passwords.plain-yaml


ldapsearch -x -H ldap://ldap.intra.bmw12.ch:389 -b dc=ldap,dc=intra,dc=bmw12,dc=ch -D "cn=admin,dc=ldap,dc=intra,dc=bmw12,dc=ch" -w


 ldapsearch -x -H ldap://ldap.intra.bmw12.ch:389 -b dc=ldap,dc=intra,dc=bmw12,dc=ch -D "cn=admin,dc=ldap,dc=intra,dc=bmw12,dc=ch" -w $LDAP_ADMIN_PASSWORD


ldapadd -x -H ldap://ldap.intra.bmw12.ch:389 -D "cn=admin,dc=ldap,dc=intra,dc=bmw12,dc=ch" -f groups.ldif -w $LDAP_ADMIN_PASSWORD
