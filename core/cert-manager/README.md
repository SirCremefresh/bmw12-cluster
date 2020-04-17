


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
kubectl apply -f certificate-staging.yaml
```

# remove cert
```
 kubectl delete certificates bmw12-ch

```

# logs
```
kubectl logs -n cert-manager deploy/cert-manager -f

```
