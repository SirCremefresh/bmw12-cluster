 helm repo add yugabytedb https://charts.yugabyte.com
 helm repo update
 
kubectl create namespace yugabytedb

helm install yugabyte yugabytedb/yugabyte --namespace yugabytedb --wait

https://docs.yugabyte.com/latest/deploy/kubernetes/single-zone/oss/helm-chart/
