
kubectl create namespace metallb-system
helm install --namespace=metallb-system  -f values.yaml metallb  stable/metallb --version 0.12.0

# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

k apply -f metallb-config.yaml 

