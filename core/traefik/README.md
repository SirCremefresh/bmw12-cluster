

```bash
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update   

kubectl create namespace traefik 


# install
helm install --namespace=traefik --values=./custom-values.yaml traefik traefik/traefik
# upgrade
helm upgrade --namespace=traefik --values=./custom-values.yaml traefik traefik/traefik
# uninsall
helm uninstall --namespace=traefik  traefik
```

