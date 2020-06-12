helm repo add gitlab https://charts.gitlab.io/
helm repo update


k create namespace gitlab 
kubectl create secret -n gitlab generic gitlab-postgres --from-file=postgres-password=./postgres-password.plain


helm install -n gitlab gitlab gitlab/gitlab -f gitlab-values.yaml --timeout 600s 

