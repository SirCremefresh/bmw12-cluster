helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


kubectl create namespace postgresql
helm install -n postgresql postgresql bitnami/postgresql-ha \
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


# give all access to a specific database


create user bmw12_iot
	createdb
	createrole;
create database bmw12_iot;

GRANT CONNECT ON DATABASE bmw12_iot TO bmw12_iot;
GRANT USAGE ON SCHEMA public TO bmw12_iot;
GRANT ALL PRIVILEGES ON DATABASE bmw12_iot TO bmw12_iot;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO bmw12_iot;
