k create namespace tekton-dockerhub-webhook

kubectl -n tekton-dockerhub-webhook create secret docker-registry docker-registry-credentials --docker-server=https://index.docker.io/v1/ --docker-username=donatowolfisberg --docker-password=pwd --docker-email=donato.wolfisberg@gmail.com
kubectl -n tekton-dockerhub-webhook patch serviceaccount default -p '{"imagePullSecrets": [{"name": "docker-registry-credentials"}]}'


helm upgrade --install -n tekton-dockerhub-webhook -f values.yaml -f bmw12-application.yaml tekton-dockerhub-webhook .
