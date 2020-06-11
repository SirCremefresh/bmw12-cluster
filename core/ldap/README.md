
k create namespace ldap
k apply -f certificate-prod.yaml
helm install -n ldap ldap stable/openldap --values ldap-values.yaml --values ldap-values-passwords.plain-yaml

helm upgrade -n ldap ldap stable/openldap --values ldap-values.yaml --values ldap-values-passwords.plain-yaml


helm uninstall -n ldap ldap


export LDAP_ADMIN_PASSWORD=$(kubectl get secret --namespace ldap ldap-openldap -o jsonpath="{.data.LDAP_ADMIN_PASSWORD}" | base64 --decode; echo)
# search all
ldapsearch -x -H ldaps://ldap.intra.bmw12.ch:636 -b dc=bmw12,dc=ch -D "cn=admin,dc=bmw12,dc=ch" -w $LDAP_ADMIN_PASSWORD


ldapsearch -x -H ldaps://ldap.intra.bmw12.ch:636 -b dc=bmw12,dc=ch -D "cn=admin,dc=bmw12,dc=ch" -w $LDAP_ADMIN_PASSWORD
ldapsearch -x -H ldaps://ldap.intra.bmw12.ch:636 -b cn=database,ou=groups,dc=bmw12,dc=ch -D "cn=admin,dc=bmw12,dc=ch" -w $LDAP_ADMIN_PASSWORD


# add groups and ou
ldapadd -x -H ldaps://ldap.intra.bmw12.ch:636 -D "cn=admin,dc=bmw12,dc=ch" -f ou.ldif -w $LDAP_ADMIN_PASSWORD
ldapadd -x -H ldaps://ldap.intra.bmw12.ch:636 -D "cn=admin,dc=bmw12,dc=ch" -f groups.ldif -w $LDAP_ADMIN_PASSWORD


# add bmw12_iot user
ldapadd -x -H ldaps://ldap.intra.bmw12.ch:636 -D "cn=admin,dc=bmw12,dc=ch" -f bmw12_iot.ldif -w $LDAP_ADMIN_PASSWORD

## change and add password
ldappasswd -x -H ldaps://ldap.intra.bmw12.ch:636 -D "cn=admin,dc=bmw12,dc=ch" -S "uid=bmw12_iot2,ou=users,dc=bmw12,dc=ch"  -w $LDAP_ADMIN_PASSWORD
