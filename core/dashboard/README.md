
# Dasboard
https://rancher.com/docs/k3s/latest/en/installation/kube-dashboard/
## installl
```shell script
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.3/aio/deploy/alternative.yaml

#deploy
kubectl apply -f dashboard.admin-user.yml -f dashboard.admin-user-role.yml

```


## access
```

#get token
kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token

# proxy
kubectl proxy  
```

## url
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
