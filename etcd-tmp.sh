#!/usr/bin/env bash

INT_NAME="enp5s0" # name vom adapter beispiel von srv01
INT_NAME="enp4s0" # name vom adapter beispiel von srv02
INT_NAME="enp3s0f1" # name vom adapter beispiel von srv03

ETCD_NAME=$(hostname -s)
ETCD_HOST_IP=$(ip addr show $INT_NAME | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)


cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd service
Documentation=https://github.com/etcd-io/etcd

[Service]
Type=notify
User=etcd
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --data-dir=/var/lib/etcd \\
  --initial-advertise-peer-urls https://${ETCD_NAME}.intra.bmw12.ch:2380 \\
  --listen-peer-urls https://${ETCD_HOST_IP}:2380 \\
  --listen-client-urls https://${ETCD_HOST_IP}:2379 \\
  --advertise-client-urls https://${ETCD_NAME}.intra.bmw12.ch:2379 \\
  --initial-cluster-token bmw12-etcd-cluster-0 \\
  --logger=zap \\
  --initial-cluster srv01=https://srv01.intra.bmw12.ch:2380,srv02=https://srv02.intra.bmw12.ch:2380,srv03=https://srv03.intra.bmw12.ch:2380 \\
  --trusted-ca-file=/etc/etcd/etcd-ca.crt \\
  --cert-file=/etc/etcd/server.crt \\
  --key-file=/etc/etcd/server.key \\
  --peer-client-cert-auth=true \\
  --peer-trusted-ca-file=/etc/etcd/etcd-ca.crt \\
  --peer-key-file=/etc/etcd/server.key \\
  --peer-cert-file=/etc/etcd/server.crt \\
  --initial-cluster-state new

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /home/bmw12/etcd/keys
mkdir -p /home/bmw12/etcd/data
sudo cp /etc/etcd/* /home/bmw12/etcd/keys/
sudo chown -R bmw12:bmw12 /home/bmw12/etcd/keys/



docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --mount type=bind,source=/home/bmw12/etcd/data,destination=/etcd-data \
  --mount type=bind,source=/home/bmw12/etcd/keys,destination=/etcd-keys \
  --name etcd-gcr-v3.4.9 \
  gcr.io/etcd-development/etcd:v3.4.9 \
  /usr/local/bin/etcd \
  --name ${ETCD_NAME} \
  --initial-advertise-peer-urls https://${ETCD_NAME}.intra.bmw12.ch:2380 \
  --listen-peer-urls https://0.0.0.0:2380 \
  --listen-client-urls https://0.0.0.0:2379 \
  --advertise-client-urls https://${ETCD_NAME}.intra.bmw12.ch:2379 \
  --initial-cluster-token bmw12-etcd-cluster-0 \
  --initial-cluster srv01=https://srv01.intra.bmw12.ch:2380,srv02=https://srv02.intra.bmw12.ch:2380,srv03=https://srv03.intra.bmw12.ch:2380 \
  --trusted-ca-file=/etcd-keys/etcd-ca.crt \
  --cert-file=/etcd-keys/server.crt \
  --key-file=/etcd-keys/server.key \
  --peer-client-cert-auth=true \
  --peer-trusted-ca-file=/etcd-keys/etcd-ca.crt \
  --peer-key-file=/etcd-keys/server.key \
  --peer-cert-file=/etcd-keys/server.crt \
  --data-dir /etcd-data \
  --initial-cluster-state new \
  --log-level info \
  --logger zap \
  --log-outputs stderr

sudo rm -r /var/lib/etcd/member
sudo rm /etc/systemd/system/etcd.service

ssh srv01 "sudo mkdir /tempdir && sudo chmod 777 /tempdir"

scp ca.pem srv01:/tempdir/etcd-ca.crt
scp srv01.pem srv01:/tempdir/server.crt
scp srv01-key.pem srv01:/tempdir/server.key

ssh srv01 "sudo mv /tempdir/etcd-ca.crt /etc/etcd/etcd-ca.crt"
ssh srv01 "sudo mv /tempdir/server.crt /etc/etcd/server.crt"
ssh srv01 "sudo mv /tempdir/server.key /etc/etcd/server.key"

ssh srv01 "sudo chmod 600 /etc/etcd/server.key"



ssh srv02 "sudo mkdir /tempdir && sudo chmod 777 /tempdir"

scp ca.pem srv02:/tempdir/etcd-ca.crt
scp srv02.pem srv02:/tempdir/server.crt
scp srv02-key.pem srv02:/tempdir/server.key

ssh srv02 "sudo mv /tempdir/etcd-ca.crt /etc/etcd/etcd-ca.crt"
ssh srv02 "sudo mv /tempdir/server.crt /etc/etcd/server.crt"
ssh srv02 "sudo mv /tempdir/server.key /etc/etcd/server.key"

ssh srv02 "sudo chmod 600 /etc/etcd/server.key"
ssh srv02 "sudo rm -r /tempdir"



ssh srv03 "sudo mkdir /tempdir && sudo chmod 777 /tempdir"

scp ca.pem srv03:/tempdir/etcd-ca.crt
scp srv03.pem srv03:/tempdir/server.crt
scp srv03-key.pem srv03:/tempdir/server.key

ssh srv03 "sudo mv /tempdir/etcd-ca.crt /etc/etcd/etcd-ca.crt"
ssh srv03 "sudo mv /tempdir/server.crt /etc/etcd/server.crt"
ssh srv03 "sudo mv /tempdir/server.key /etc/etcd/server.key"

ssh srv03 "sudo chmod 600 /etc/etcd/server.key"
ssh srv03 "sudo rm -r /tempdir"




export NAME=srv01
export ADDRESS=192.168.1.10,$NAME.intra.bmw12.ch,$NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME

export NAME=srv02
export ADDRESS=192.168.1.13,$NAME.intra.bmw12.ch,$NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME

export NAME=srv03
export ADDRESS=192.168.1.17,$NAME.intra.bmw12.ch,$NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME

etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --ca-file=/home/donato/etcd-ca/ca.pem member list

etcdctl --endpoints="https://srv01.intra.bmw12.ch:2379" --cacert=~/etcd-ca/ca.pem  member list
etcdctl --endpoints "https://srv01.intra.bmw12.ch:2379" --ca-file=~/etcd-ca/ca.pem  get /
etcdctl --endpoints="https://srv01.intra.bmw12.ch:2379" --ca-file=/home/donato/etcd-ca/ca.pem auth enable

etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --ca-file=/home/donato/etcd-ca/ca.pem --cert-file=/home/donato/etcd-ca/ca.pem --key-file=/home/donato/etcd-ca/ca-key.pem member list


sudo chown -R etcd:etcd /var/lib/etcd/
sudo chown -R etcd:etcd /etc/etcd/


sudo systemctl daemon-reload
sudo systemctl restart etcd

sudo systemctl stop etcd

sudo systemctl status etcd
