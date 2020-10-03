# Pipeline
kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.16.3/release.yaml

# Dashboard
https://github.com/tektoncd/dashboard/blob/master/docs/install.md
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml

# Triggers
kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/previous/v0.8.1/release.yaml


k create namespace tekton-runs


couldn't retrieve referenced input PipelineResource: pipelineresource.tekton.dev "arthurk-tekton-example" not found


https://www.arthurkoziel.com/creating-ci-pipelines-with-tekton-part-2/
