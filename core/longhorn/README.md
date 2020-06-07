kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml


kubectl create secret -n longhorn-system generic backblace-secret \
    --from-file=AWS_ACCESS_KEY_ID=./backblace-key-id.plain \
    --from-file=AWS_SECRET_ACCESS_KEY=./backblace-access-key.plain \
    --from-file=AWS_ENDPOINTS=./backblace-endpoint.plain \
    --dry-run=client -o yaml | kubectl apply -f -

# Backblace
## Backup Target
s3://{bucket-name}@{region}/
s3://bmw12-longhorn@us-west-002/

## endpoint
https://s3.us-west-002.backblazeb2.com


# make default

kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
