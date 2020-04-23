

```
helm repo add traefik https://containous.github.io/traefik-helm-chart
helm repo update   

kubectl create namespace traefik 

kubectl apply -f certificate-staging.yaml


# install
helm install --namespace=traefik --values=./custom-values.yaml traefik traefik/traefik
# upgrade
helm upgrade --namespace=traefik --values=./custom-values.yaml traefik traefik/traefik
# uninsall
helm uninstall --namespace=traefik  traefik
```

```shell script
scp ~/.kube/config bmw12@srv01.intra.bmw12.ch:/etc/rancher/k3s/k3s.yaml 

```




github: https://github.com/rancher/k3s/issues/1141
/var/lib/rancher/k3s/server/manifests

apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: traefik
  namespace: kube-system
spec:
  chart: traefik
  repo: https://containous.github.io/traefik-helm-chart
  set:
    image.tag: "2.2"
