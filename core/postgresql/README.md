helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


kubectl create namespace postgresql
k apply -f extended-postgresql-config.yaml
helm install -n postgresql postgresql bitnami/postgresql \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 9.8.4

CREATE EXTENSION pg_stat_statements;

helm upgrade -n postgresql postgresql bitnami/postgresql \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 9.8.4
    
    
helm template -n postgresql postgresql bitnami/postgresql \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 9.8.4 > templated.yaml


k apply -n postgresql -f backup-secret.plain-yaml
k apply -n postgresql -f backup-cronjob.yaml

#manualy trigger
k -n postgresql create job \
    --from=cronjob/bmw12-simple-postgresql-backup \
    bmw12-simple-postgresql-backup-manually

#delete
helm delete postgresql -n postgresql
kubectl delete pvc --namespace postgresql -l app.kubernetes.io/component=postgresql
kubectl delete namespace postgresql

