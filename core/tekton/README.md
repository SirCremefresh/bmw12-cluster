# Pipeline
kubectl apply --filename https://github.com/tektoncd/pipeline/releases/download/v0.17.0/release.yaml

# Dashboard
https://github.com/tektoncd/dashboard/blob/master/docs/install.md
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/download/v0.10.0/tekton-dashboard-release.yaml

# Triggers
kubectl apply --filename https://github.com/tektoncd/triggers/releases/download/v0.8.1/release.yaml


k create namespace tekton-runs


couldn't retrieve referenced input PipelineResource: pipelineresource.tekton.dev "arthurk-tekton-example" not found


https://www.arthurkoziel.com/creating-ci-pipelines-with-tekton-part-2/
