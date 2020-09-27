kubectl create namespace nginx-ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install --namespace=nginx-ingress nginx-ingress ingress-nginx/ingress-nginx


helm upgrade -f  nginx-ingress-values.yaml --namespace=nginx-ingress nginx-ingress ingress-nginx/ingress-nginx
