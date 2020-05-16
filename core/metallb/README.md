
kubectl create namespace metallb-system
helm install --namespace=metallb-system  -f values.yaml metallb  stable/metallb --version 0.12.0


kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"


k apply -f metallb-config.yaml 


# label nodes
k label nodes srv01 metallb=
k label nodes srv02 metallb=
