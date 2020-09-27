kubectl apply -f https://download.elastic.co/downloads/eck/1.2.1/all-in-one.yaml


5mh8p9T0lBi1r6TR315DM8gJ
kubectl get secret quickstart-es-elastic-user -o go-template='{{.data.elastic | base64decode}}'


add_kubernetes_metadata


Exiting: Failed to start crawler: starting input failed: Error while initializing input: fail to unpack the kubernetes configuration: missing field accessing 'filebeat.inputs.0.processors.0.add_kubernetes_metadata.host' (source:'/etc/beat.yml')\n
