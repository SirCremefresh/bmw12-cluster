

kubectl create namespace monitoring

#grafana
helm install --namespace=monitoring grafana stable/grafana --version 5.0.26 --values=grafana-values.yaml


#prometheus
helm install --namespace=monitoring prometheus stable/prometheus --version=11.3.0 --values=preometheus-values.yaml
helm upgrade --namespace=monitoring prometheus stable/prometheus --version=11.3.0 --values=preometheus-values.yaml
