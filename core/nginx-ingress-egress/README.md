kubectl create namespace nginx-ingress-egress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install  -f nginx-ingress-egress-values.yaml --namespace=nginx-ingress-egress nginx-ingress-egress ingress-nginx/ingress-nginx


chart repo: https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx

helm upgrade -f nginx-ingress-egress-values.yaml --namespace=nginx-ingress-egress nginx-ingress-egress ingress-nginx/ingress-nginx
