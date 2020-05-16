

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm repo update

kubectl create namespace cattle-system

helm install -f values.yaml --namespace cattle-system rancher rancher-latest/rancher --set tls=external
