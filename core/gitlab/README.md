helm repo add gitlab https://charts.gitlab.io/
helm repo update


k create namespace gitlab 

# database shit 
GRANT CONNECT ON DATABASE gitlab TO gitlab;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gitlab;
GRANT ALL PRIVILEGES ON DATABASE gitlab TO gitlab;

create extension pg_trgm



kubectl create secret -n gitlab generic gitlab-postgres --from-file=postgres-password=./postgres-password.plain


helm install -n gitlab gitlab gitlab/gitlab -f gitlab-values.yaml --timeout 600s 
helm upgrade -n gitlab gitlab gitlab/gitlab -f gitlab-values.yaml --timeout 600s 

# redis

helm install -n gitlab redis bitnami/redis \
    -f redis/redis-values.yaml \
    -f redis/redis-values-passwords.plain-yaml
