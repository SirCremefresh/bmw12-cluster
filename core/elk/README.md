kubectl apply -f https://download.elastic.co/downloads/eck/1.2.1/all-in-one.yaml


PASSWORD=$(kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')


add_kubernetes_metadata


Exiting: Failed to start crawler: starting input failed: Error while initializing input: fail to unpack the kubernetes configuration: missing field accessing 'filebeat.inputs.0.processors.0.add_kubernetes_metadata.host' (source:'/etc/beat.yml')\n


k delete Elasticsearch quickstart
k delete Beat quickstart
k delete Kibana quickstart
