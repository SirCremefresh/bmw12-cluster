helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


kubectl create namespace postgresql
helm install -n postgresql postgresql bitnami/postgresql \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 9.8.1


helm upgrade -n postgresql postgresql bitnami/postgresql-ha \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 9.8.1

#delete
helm delete postgresql -n postgresql
kubectl delete pvc --namespace postgresql -l app.kubernetes.io/component=postgresql
kubectl delete namespace postgresql

