
k create namespace redis
helm install -n redis redis bitnami/redis --values redis-values.yaml
