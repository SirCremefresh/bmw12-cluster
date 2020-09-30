https://longhorn.io/docs/1.0.2/advanced-resources/deploy/customizing-default-settings/#using-helm
helm repo add longhorn https://charts.longhorn.io
helm repo update


k create namespace longhorn-system

kubectl create secret -n longhorn-system generic backblace-secret \
    --from-file=AWS_ACCESS_KEY_ID=./backblace-key-id.plain \
    --from-file=AWS_SECRET_ACCESS_KEY=./backblace-access-key.plain \
    --from-file=AWS_ENDPOINTS=./backblace-endpoint.plain \
    --dry-run=client -o yaml | kubectl apply -f -


helm install --namespace longhorn-system --values longhorn-values.yaml longhorn longhorn/longhorn

# Backblace
## Backup Target
s3://{bucket-name}@{region}/
s3://bmw12-longhorn@us-west-002/

## endpoint
https://s3.us-west-002.backblazeb2.com


