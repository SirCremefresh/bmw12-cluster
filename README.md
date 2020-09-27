# BMW12 Kubernetes Cluster


## Install
```bash
# install on srv01
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -s - server --disable servicelb --disable traefik --no-deploy traefik --no-deploy servicelb --docker
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
scp bmw12@srv01.intra.bmw12.ch:/etc/rancher/k3s/k3s.yaml ~/.kube/config

# change localhost to dns
sed -i 's/127\.0\.0\.1/kubeapi\.intra\.bmw12\.ch/g' ~/.kube/config
```

# Secrets
https://makandracards.com/makandra-orga/37763-gpg-extract-private-key-and-import-on-different-machine
https://www.howtogeek.com/427982/how-to-encrypt-and-decrypt-files-with-gpg-on-linux/

```bash
# import private key (private key is on google drive)
gpg --import private.key

# list keys
gpg --list-secret-keys

# remove passphfrase from private local private key
gpg --edit-key bmw12
passwd (enter current passphrase then enter nothing for new passphrase)
trust (then level 5)
CRT+C (to exit)

# encrypt file
gpg --encrypt --sign --armor -r bmw12 name_of_file

# decrypt file
gpg --decrypt -r bmw12 enrypted_file > output_file

```

# Laptop
## lid
https://askubuntu.com/questions/141866/keep-ubuntu-server-running-on-a-laptop-with-the-lid-closed

# restart node
k drain srv03 --force --ignore-daemonsets --delete-local-data
kubectl uncordon srv03

# RPI help

start gui from ssh on x server
export DISPLAY=:0
lxterminal --geometry=150x50 -e "htop"



# evict and shit

k drain srv03 --ignore-daemonsets --force --delete-local-data
k uncordon srv02 



docker stop $(docker ps -a -q --filter="name=k8s*")
