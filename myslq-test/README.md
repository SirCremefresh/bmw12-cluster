k create namespace mysql-test

helm install --namespace=mysql-test mysql-test stable/mysql \
    --set mysqlRootPassword=secretpassword,mysqlUser=my-user,mysqlPassword=my-password,mysqlDatabase=my-database \
    --set persistence.storageClass=longhorn \
    --set service.type=LoadBalancer 
