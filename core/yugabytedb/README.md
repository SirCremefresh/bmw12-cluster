 helm repo add yugabytedb https://charts.yugabyte.com
 helm repo update
 
kubectl create namespace yugabytedb

helm install yugabyte yugabytedb/yugabyte --namespace yugabytedb \
--set persistentVolume.storageClass=longhorn,resource.master.requests.cpu=0.5,resource.master.requests.memory=0.5Gi,\
resource.tserver.requests.cpu=0.5,resource.tserver.requests.memory=0.5Gi --wait


helm install yugabytedb yugabytedb/yugabyte --namespace yugabytedb --values values.yaml

https://docs.yugabyte.com/latest/deploy/kubernetes/single-zone/oss/helm-chart/


Cleanup YugabyteDB Pods
helm delete yugabytedb -n yugabytedb
NOTE: You need to manually delete the persistent volume
kubectl delete pvc --namespace yugabytedb -l app=yb-master
kubectl delete pvc --namespace yugabytedb -l app=yb-tserver
