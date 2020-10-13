kubectl apply -f https://download.elastic.co/downloads/eck/1.2.1/all-in-one.yaml

PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')


https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-beat-configuration-examples.html


increase mmap
https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

k -n elk delete Elasticsearch elasticsearch
k -n elk delete Beat filebeat
k delete Beat metricbeat
k -n elk delete Kibana kibana

# Data & Disk
The disk size and storage should be managed thourght lifeycle policies.
