kubectl apply -f https://download.elastic.co/downloads/eck/1.2.1/all-in-one.yaml


PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')


https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-beat-configuration-examples.html


increase mmap
https://www.elastic.co/guide/en/elasticsearch/reference/current/vm-max-map-count.html

k delete Elasticsearch quickstart
k delete Beat filebeat
k delete Beat metricbeat
k delete Kibana quickstart