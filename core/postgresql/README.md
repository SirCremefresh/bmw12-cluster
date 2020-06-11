helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


kubectl create namespace postgresql2
helm install -n postgresql2 postgresql2 bitnami/postgresql-ha \
    --values=postgresql-values.yaml \
    --values=postgresql-values-passwords.plain-yaml \
    --version 3.2.9


helm upgrade -n postgresql2 postgresql2 bitnami/postgresql-ha \
    --values=postgresql-values.yaml \
    --values=postgresql-values-passwords.plain-yaml \
    --version 3.2.9

#delete
helm delete postgresql -n postgresql
kubectl delete pvc --namespace postgresql -l app.kubernetes.io/component=postgresql
kubectl delete namespace postgresql
