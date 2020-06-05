# BMW12 Kubernetes Cluster


## Install
```bash
# install on srv01
curl -sfL https://get.k3s.io | "INSTALL_K3S_VERSION=v1.18.3" sh -s - server --disable servicelb --disable traefik --no-deploy traefik --no-deploy servicelb --docker --datastore-endpoint="https://srv01.intra.bmw12.ch:2379,https://srv02.intra.bmw12.ch:2379,https://srv03.intra.bmw12.ch:2379" --datastore-cafile="/home/bmw12/etcd/keys/etcd-ca.crt" --datastore-certfile="/home/bmw12/etcd/keys/etcd-ca.crt" --datastore-keyfile="/home/bmw12/etcd/keys/ca-key.pem"
# get token from master
sudo cat /var/lib/rancher/k3s/server/node-token  

# install agent 
# replace the token with token
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_URL="https://kubeapi.intra.bmw12.ch:6443" K3S_TOKEN="the_token" sh -s - --docker
```

# add default helm repo
```bash
helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
```

## Remote Connect
```bash
# install kubectl and helm
snap install kubectl --classic 
sudo snap install helm --classic


# get config from server

ssh bmw12@srv01.intra.bmw12.ch "sudo cp /etc/rancher/k3s/k3s.yaml /home/bmw12/k3s-tmp && sudo chown bmw12 /home/bmw12/k3s-tmp"
scp bmw12@srv01.intra.bmw12.ch:/home/bmw12/k3s-tmp ~/.kube/config
ssh bmw12@srv01.intra.bmw12.ch "sudo rm /home/bmw12/k3s-tmp"

# change localhost to dns
sed -i 's/127\.0\.0\.1/kubeapi\.intra\.bmw12\.ch/g' ~/.kube/config
```

# Laptop
## lid
https://askubuntu.com/questions/141866/keep-ubuntu-server-running-on-a-laptop-with-the-lid-closed




# RPI help

start gui from ssh on x server
export DISPLAY=:0
lxterminal --geometry=150x50 -e "htop"



