# BMW12 Kubernetes Cluster


## Install
```shell script
# install on srv01
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s - --disable servicelb --disable traefik --no-deploy traefik --no-deploy servicelb --docker
# get token
sudo cat /var/lib/rancher/k3s/server/node-token  

# install agent srv02
# replace the token with token
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_URL="https://kubeapi.intra.bmw12.ch:6443" K3S_TOKEN="the_token" sh -s - --docker
```

helm repo add stable https://kubernetes-charts.storage.googleapis.com

## Remote Connect
```shell script
# install kubectl and helm
snap install kubectl --classic 
sudo snap install helm --classic


# get config from server
scp bmw12@srv01.intra.bmw12.ch:/etc/rancher/k3s/k3s.yaml ~/.kube/config
# change localhost to dns
sed -i 's/127\.0\.0\.1/srv01\.intra\.bmw12\.ch/g' ~/.kube/config
```

# Laptop
## lid
https://askubuntu.com/questions/141866/keep-ubuntu-server-running-on-a-laptop-with-the-lid-closed




# RPI help

start gui from ssh on x server
export DISPLAY=:0
 lxterminal --geometry=150x50 -e "htop"
