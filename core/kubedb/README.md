https://kubedb.com/docs/v0.13.0-rc.0/setup/install/

kubectl create namespace kubedb

helm install kubedb-operator appscode/kubedb --version 0.12.0 \
  --namespace kubedb

 helm install kubedb-catalog appscode/kubedb-catalog --version 0.12.0 \
  --namespace kubedb
