helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


kubectl create namespace postgresql
helm install --namespace postgresql postgresql bitnami/postgresql-ha --values=values.yaml --version 3.2.9


helm upgrade --namespace postgresql postgresql bitnami/postgresql-ha --values=values.yaml --version 3.2.9

#delete
helm delete postgresql -n postgresql
kubectl delete pvc --namespace postgresql -l app.kubernetes.io/component=postgresql
kubectl delete namespace postgresql