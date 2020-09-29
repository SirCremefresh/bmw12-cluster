kubectl create namespace nginx-ingress-egress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install  -f nginx-ingress-egress-values.yaml --namespace=nginx-ingress-egress nginx-ingress-egress ingress-nginx/ingress-nginx


chart repo: https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx

helm upgrade -f nginx-ingress-egress-values.yaml --namespace=nginx-ingress-egress nginx-ingress-egress ingress-nginx/ingress-nginx


kubectl create secret -n nginx-ingress-egress generic github-oauth-secret \
    --from-file=OAUTH2_PROXY_CLIENT_ID=./github-oauth-client-id.plain \
    --from-file=OAUTH2_PROXY_CLIENT_SECRET=./github-oauth-client-secret.plain \
    --from-file=OAUTH2_PROXY_COOKIE_SECRET=./github-oauth-cookie-secret.plain \
    --dry-run=true -o yaml | kubectl apply -f -


# Oauth2 Ingresses
helm install --namespace=nginx-ingress-egress oauth2-ingress ./oauth2-ingress
helm upgrade --namespace=nginx-ingress-egress oauth2-ingress ./oauth2-ingress
