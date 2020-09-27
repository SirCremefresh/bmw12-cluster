
kubectl create namespace metallb-system
helm install --namespace=metallb-system  -f values.yaml metallb  bitnami/metallb --version 0.1.24

# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

k apply -f metallb-config.yaml 

