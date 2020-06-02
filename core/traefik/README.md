

```bash
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update   

kubectl create namespace traefik 


# install
helm install --namespace=traefik --values=./custom-values.yaml traefik traefik/traefik
# upgrade
helm upgrade --namespace=traefik --values=./custom-values.yaml traefik traefik/traefik --version 8.2.1 
# uninsall
helm uninstall --namespace=traefik  traefik
```


# intellij crd urls

https://raw.githubusercontent.com/containous/traefik/master/docs/content/reference/dynamic-configuration/kubernetes-crd-definition.yml
