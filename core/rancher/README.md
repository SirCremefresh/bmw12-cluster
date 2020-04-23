

helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

helm install rancher rancher-latest/rancher \
  --namespace cattle-system \
  --set hostname=rancher.intra.bmw12.ch
