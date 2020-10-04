k create namespace sample-application

kubectl -n sample-application patch serviceaccount default -p '{"imagePullSecrets": [{"name": "docker-registry-credentials"}]}'
kubectl -n sample-application create secret docker-registry docker-registry-credentials --docker-server=https://index.docker.io/v1/ --docker-username=donatowolfisberg --docker-password=pwd --docker-email=donato.wolfisberg@gmail.com
