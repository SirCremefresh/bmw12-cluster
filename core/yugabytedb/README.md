 helm repo add yugabytedb https://charts.yugabyte.com
 helm repo update
 
kubectl create namespace yugabytedb

helm install yugabyte yugabytedb/yugabyte --namespace yugabytedb \
--set persistentVolume.storageClass=longhorn,resource.master.requests.cpu=0.5,resource.master.requests.memory=0.5Gi,\
resource.tserver.requests.cpu=0.5,resource.tserver.requests.memory=0.5Gi --wait

https://docs.yugabyte.com/latest/deploy/kubernetes/single-zone/oss/helm-chart/
