# Pipeline
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.18.1/release.yaml

# Dashboard
https://github.com/tektoncd/dashboard/blob/master/docs/install.md
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.11.1/tekton-dashboard-release.yaml

# Triggers
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.10.0/release.yaml


k create namespace tekton-runs


couldn't retrieve referenced input PipelineResource: pipelineresource.tekton.dev "arthurk-tekton-example" not found


https://www.arthurkoziel.com/creating-ci-pipelines-with-tekton-part-2/



kubectl -n tekton-pipelines create secret docker-registry docker-registry-credentials --docker-server=https://index.docker.io/v1/ --docker-username=donatowolfisberg --docker-password=pwd --docker-email=donato.wolfisberg@gmail.com
kubectl -n tekton-pipelines patch serviceaccount default -p '{"imagePullSecrets": [{"name": "docker-registry-credentials"}]}'


kubectl -n tekton-pipelines create secret generic gpg-private-key \
  --from-file=private.key=./secrets/private-key.plain \
  --from-file=passphrase.txt=./secrets/private-key-passphrase.plain



# delete all task runs
k -n tekton-pipelines delete taskrun --all 
