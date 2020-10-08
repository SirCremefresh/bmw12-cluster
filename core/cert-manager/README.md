
# install resources
```
kubectl create namespace cert-manager
helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.3 \
  --set installCRDs=true

helm upgrade \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.0.3 \
  --set installCRDs=true

```

# create service account
```
gcloud --project=sircremefresh iam service-accounts create dns01-solver --display-name "dns01-solver"

gcloud projects add-iam-policy-binding sircremefresh \
   --member serviceAccount:dns01-solver@sircremefresh.iam.gserviceaccount.com \
   --role roles/dns.admin

gcloud --project=sircremefresh iam service-accounts create dns01-solver

```


# add credentials to clustert 
```
gcloud --project=sircremefresh iam service-accounts keys create key.json \
   --iam-account dns01-solver@sircremefresh.iam.gserviceaccount.com

kubectl create -n cert-manager secret generic clouddns-dns01-solver-svc-acct \
   --from-file=key.json
```


# apply
```
kubectl apply -f cluster-issuer.letsencrypt-staging.yaml
kubectl apply -f cluster-issuer.letsencrypt-prod.yaml
```

# remove cert
```
 kubectl delete certificates staging-bmw12-ch

```

# logs
```
kubectl logs -n cert-manager deploy/cert-manager -f

```
