# etcd
install form:  
https://computingforgeeks.com/setup-etcd-cluster-on-centos-debian-ubuntu/

tls + certificates:  
https://pcocc.readthedocs.io/en/latest/deps/etcd-production.html

docker image
github etcd releases


# setup

```bash
# certifikate generieren von: https://pcocc.readthedocs.io/en/latest/deps/etcd-production.html

export NAME=srv01
export ADDRESS=192.168.1.10,$NAME.intra.bmw12.ch,$NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME

export NAME=srv02
export ADDRESS=192.168.1.13,$NAME.intra.bmw12.ch,$NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME

export NAME=srv03
export ADDRESS=192.168.1.17,$NAME.intra.bmw12.ch,$NAME
echo '{"CN":"'$NAME'","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -config=ca-config.json -ca=ca.pem -ca-key=ca-key.pem -hostname="$ADDRESS" - | cfssljson -bare $NAME


ssh srv01 "mkdir -p /home/bmw12/etcd/keys && mkdir -p /home/bmw12/etcd/data"

scp ca.pem srv01:/home/bmw12/etcd/keys/etcd-ca.crt
scp ca-key.pem srv01:/home/bmw12/etcd/keys/ca-key.pem
scp srv01.pem srv01:/home/bmw12/etcd/keys/server.crt
scp srv01-key.pem srv01:/home/bmw12/etcd/keys/server.key

ssh srv01 "sudo chmod 600 /home/bmw12/etcd/keys/server.key"



ssh srv02 "mkdir -p /home/bmw12/etcd/keys && mkdir -p /home/bmw12/etcd/data"

scp ca.pem srv02:/home/bmw12/etcd/keys/etcd-ca.crt
scp ca-key.pem srv02:/home/bmw12/etcd/keys/ca-key.pem
scp srv02.pem srv02:/home/bmw12/etcd/keys/server.crt
scp srv02-key.pem srv02:/home/bmw12/etcd/keys/server.key

ssh srv02 "sudo chmod 600 /home/bmw12/etcd/keys/server.key"


ssh srv03 "mkdir -p /home/bmw12/etcd/keys && mkdir -p /home/bmw12/etcd/data"

scp ca.pem srv03:/home/bmw12/etcd/keys/etcd-ca.crt
scp ca-key.pem srv03:/home/bmw12/etcd/keys/ca-key.pem
scp srv03.pem srv03:/home/bmw12/etcd/keys/server.crt
scp srv03-key.pem srv03:/home/bmw12/etcd/keys/server.key

ssh srv03 "sudo chmod 600 /home/bmw12/etcd/keys/server.key"



# start containers then enable auth
export ETCDCTL_API=3
etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/srv01.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem auth enable


```


#commands
```bash
# get members
export ETCDCTL_API=3
etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/srv01.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem member list

# get status of members
etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/ca.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem endpoint status -w table
etcdctl --endpoints=https://srv02.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/ca.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem endpoint status -w table
etcdctl --endpoints=https://srv03.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/ca.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem endpoint status -w table

#testing write
etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/srv01.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem put /test hello
etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/srv01.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem get /test
etcdctl --endpoints=https://srv01.intra.bmw12.ch:2379 --cacert=/home/donato/etcd-ca/srv01.pem --cert=/home/donato/etcd-ca/ca.pem --key=/home/donato/etcd-ca/ca-key.pem del /test
```

# run
```bash
ETCD_NAME=$(hostname -s)

docker run \
  -p 2379:2379 -p 2380:2380 --restart unless-stopped \
  --mount type=bind,source=/home/bmw12/etcd/data,destination=/etcd-data \
  --mount type=bind,source=/home/bmw12/etcd/keys,destination=/etcd-keys \
  --name bmw12-etcd-cluster-0 \
  -d \
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
```
