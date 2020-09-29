helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


kubectl create namespace postgresql
k apply -f extended-postgresql-config.yaml
helm install -n postgresql postgresql bitnami/postgresql \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 9.8.1

CREATE EXTENSION pg_stat_statements;

helm upgrade -n postgresql postgresql bitnami/postgresql \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 9.8.1

#delete
helm delete postgresql -n postgresql
kubectl delete pvc --namespace postgresql -l app.kubernetes.io/component=postgresql
kubectl delete namespace postgresql

