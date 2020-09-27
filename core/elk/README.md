kubectl apply -f https://download.elastic.co/downloads/eck/1.2.1/all-in-one.yaml


PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')


https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-beat-configuration-examples.html


k delete Elasticsearch quickstart
k delete Beat quickstart
k delete Kibana quickstart
