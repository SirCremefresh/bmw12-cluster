
kubectl create namespace metallb-system
helm install --namespace=metallb-system  -f values.yaml metallb  stable/metallb --version 0.12.0


k apply -f metallb-config.yaml 


# label nodes
k label nodes srv01 metallb=
k label nodes srv02 metallb=
