helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update


kubectl create namespace postgresql
helm install -n postgresql postgresql bitnami/postgresql-ha \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 3.5.1


helm upgrade -n postgresql postgresql bitnami/postgresql-ha \
    -f=postgresql-values.yaml \
    -f=postgresql-values-passwords.plain-yaml \
    --version 3.5.1

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
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bmw12_iot;
GRANT ALL PRIVILEGES ON DATABASE bmw12_iot TO bmw12_iot;


# on error
delete statefulset   
k delete -n postgresql sts --cascade=false postgresql-postgresql-ha-postgresql   
k delete -n postgresql sts  postgresql-postgresql-ha-postgresql   

copy statefulset definition from dashboard and change 
podManagementPolicy to Parallel


# local network
https://gitlab.com/gitlab-org/gitlab-foss/-/issues/57948
